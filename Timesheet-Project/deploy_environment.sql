SET NOCOUNT ON;

-- #############################################################################
-- PURPOSE
-- The package's "SQLServer" connection manager has a server name baked in at
-- design time (whatever machine it was built/tested against). When the
-- project is deployed to a different SSISDB catalog (e.g. the partner's
-- server) and executed there, nothing overrides that connection manager, so
-- it tries to reach the design-time server and fails with:
--   "Login timeout expired"
--   "Server is not found or not accessible"
--   "Named Pipes Provider: Could not open a connection to SQL Server [53]"
--
-- This script creates an SSISDB Environment scoped to the target folder,
-- adds a variable holding the CORRECT server name for wherever this is being
-- deployed, references that environment on the project, and maps the
-- connection manager's ServerName property to pull from it at runtime.
--
-- Must run AFTER deploy_ssis.sql (project must already exist in the folder)
-- and BEFORE deploy_job.sql executes the package (the job step must include
-- /ENVREFERENCE pointing at the reference_id this script creates -- see
-- updated deploy_job.sql).
--
-- Parameters (sqlcmd variables):
--   $(FolderName)         e.g. Timesheet ETL
--   $(ProjectName)        e.g. Timesheet Project
--   $(PackageName)        e.g. Timesheets.dtsx
--   $(EnvironmentName)    e.g. TimesheetEnv
--   $(TargetSqlServer)    the ACTUAL server the package should connect to at
--                         this destination (local dev box name, or the
--                         partner's own @@SERVERNAME)
--   $(ConnectionManagerName)  e.g. SQLServer
-- #############################################################################

USE [SSISDB];
GO

DECLARE @folder_name        nvarchar(128)  = N'$(FolderName)';
DECLARE @project_name       nvarchar(128)  = N'$(ProjectName)';
DECLARE @package_name       nvarchar(260)  = N'$(PackageName)';
DECLARE @environment_name   nvarchar(128)  = N'$(EnvironmentName)';
DECLARE @target_sql_server  nvarchar(128)  = N'$(TargetSqlServer)';
DECLARE @cm_name            nvarchar(128)  = N'$(ConnectionManagerName)';

DECLARE @env_var_name       nvarchar(128)  = N'SqlServerName';
DECLARE @reference_id       bigint;

BEGIN TRY

    BEGIN TRANSACTION;

    -- ---------------------------------------------------------------------
    -- 1. Create the environment if it doesn't already exist
    -- ---------------------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1
        FROM   [catalog].[environments] e
        JOIN   [catalog].[folders] f ON f.folder_id = e.folder_id
        WHERE  f.name = @folder_name
          AND  e.name = @environment_name
    )
    BEGIN
        PRINT 'Creating environment [' + @environment_name + '] in folder [' + @folder_name + ']...';
        EXEC [catalog].[create_environment]
            @folder_name      = @folder_name,
            @environment_name = @environment_name;
    END
    ELSE
    BEGIN
        PRINT 'Environment [' + @environment_name + '] already exists.';
    END

    -- ---------------------------------------------------------------------
    -- 2. Create or update the server-name variable on the environment
    -- ---------------------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1
        FROM   [catalog].[environment_variables] ev
        JOIN   [catalog].[environments] e ON e.environment_id = ev.environment_id
        JOIN   [catalog].[folders] f ON f.folder_id = e.folder_id
        WHERE  f.name = @folder_name
          AND  e.name = @environment_name
          AND  ev.name = @env_var_name
    )
    BEGIN
        PRINT 'Creating environment variable [' + @env_var_name + ']...';
        EXEC [catalog].[create_environment_variable]
            @folder_name      = @folder_name,
            @environment_name = @environment_name,
            @variable_name    = @env_var_name,
            @data_type        = N'String',
            @sensitive        = 0,
            @value            = @target_sql_server,
            @description       = N'Target SQL Server for the SQLServer connection manager at this deployment destination.';
    END
    ELSE
    BEGIN
        PRINT 'Updating environment variable [' + @env_var_name + '] to [' + @target_sql_server + ']...';
        EXEC [catalog].[set_environment_variable_value]
            @folder_name      = @folder_name,
            @environment_name = @environment_name,
            @variable_name    = @env_var_name,
            @value            = @target_sql_server;
    END

    -- ---------------------------------------------------------------------
    -- 3. Reference the environment on the project (idempotent)
    -- ---------------------------------------------------------------------
    IF NOT EXISTS (
        SELECT 1
        FROM   [catalog].[environment_references] er
        JOIN   [catalog].[projects] p ON p.project_id = er.project_id
        JOIN   [catalog].[folders] f ON f.folder_id = p.folder_id
        WHERE  f.name = @folder_name
          AND  p.name = @project_name
          AND  er.environment_name = @environment_name
    )
    BEGIN
        PRINT 'Creating environment reference on project [' + @project_name + ']...';
        EXEC [catalog].[create_environment_reference]
            @folder_name        = @folder_name,
            @project_name       = @project_name,
            @environment_name    = @environment_name,
            @reference_type      = N'R',   -- Relative: same folder as the project
            @reference_id        = @reference_id OUTPUT;
    END
    ELSE
    BEGIN
        SELECT @reference_id = er.reference_id
        FROM   [catalog].[environment_references] er
        JOIN   [catalog].[projects] p ON p.project_id = er.project_id
        JOIN   [catalog].[folders] f ON f.folder_id = p.folder_id
        WHERE  f.name = @folder_name
          AND  p.name = @project_name
          AND  er.environment_name = @environment_name;

        PRINT 'Environment reference already exists (reference_id = ' + CAST(@reference_id AS nvarchar(20)) + ').';
    END

    -- ---------------------------------------------------------------------
    -- 4. Map the connection manager's ServerName property to the env var
    --    This is the actual fix for the connection failure: it tells SSISDB
    --    to override the design-time server name at execution time with
    --    whatever value the environment variable holds.
    -- ---------------------------------------------------------------------
    PRINT 'Mapping connection manager [' + @cm_name + '].ServerName to environment variable [' + @env_var_name + ']...';

    EXEC [catalog].[set_object_parameter]
        @folder_name         = @folder_name,
        @project_name        = @project_name,
        @object_name          = @package_name,
        @parameter_name       = N'CM.' + @cm_name + N'.ServerName',
        @object_type          = N'SSIS_PACKAGEs',
        @parameter_value      = @env_var_name,
        @value_type           = N'R';   -- R = value comes from a referenced environment variable

    COMMIT TRANSACTION;

    PRINT 'Environment setup completed. reference_id = ' + CAST(@reference_id AS nvarchar(20)) + '. '
        + 'Use this reference_id in the /ENVREFERENCE argument of the job step.';

    -- Emit the reference_id as a result set so the calling pipeline (or a
    -- following script) can pick it up programmatically if needed.
    SELECT @reference_id AS reference_id;

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

    DECLARE @err_msg nvarchar(4000) = ERROR_MESSAGE();
    PRINT 'ERROR configuring environment: ' + @err_msg;
    RAISERROR (@err_msg, 16, 1);

END CATCH
GO