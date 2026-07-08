USE msdb;
GO

EXECUTE AS LOGIN = 'SAMBE2025008'

SET NOCOUNT ON;

DECLARE @job_name      sysname        = N'$(JobName)';
DECLARE @server_name   nvarchar(128)  = N'$(ServerName)';
DECLARE @ssis_folder   nvarchar(128)  = N'$(SsisFolder)';
DECLARE @ssis_project  nvarchar(128)  = N'$(SsisProject)';
DECLARE @ssis_package  nvarchar(260)  = N'$(SsisPackage)';
DECLARE @job_owner     sysname        = NULLIF(N'$(JobOwner)', N'NULL');
DECLARE @job_enabled   tinyint        = CAST('$(JobEnabled)' AS tinyint);
DECLARE @operator_name sysname        = N'$(OperatorName)';
DECLARE @env_reference_id bigint      = CAST('$(EnvironmentReferenceId)' AS bigint);

-- #############################################################################
-- FIX: without /ENVREFERENCE, the environment/variable mapping created by
-- deploy_environment.sql (which overrides the SQLServer connection manager's
-- ServerName at runtime) is never applied. The job would keep connecting to
-- whatever server was baked into the connection manager at design time,
-- producing "Login timeout expired" / "Server is not found or not
-- accessible" errors on any server other than the original dev machine.
-- @(EnvironmentReferenceId) must be the reference_id returned by
-- deploy_environment.sql for this folder/project.
-- #############################################################################

DECLARE @ssis_command  nvarchar(max);
DECLARE @ReturnCode    INT = 0;
DECLARE @jobId         BINARY(16);

-- #############################################################################
-- FIX: SQL Agent + SSIS subsystem steps cannot be started by a job whose
-- owner is a SQL Server Authentication login. If @owner_login_name is passed
-- as NULL, sp_add_job defaults the owner to the CURRENT login executing this
-- batch -- which, over sqlcmd with -U/-P, is a SQL-auth login. That silently
-- bakes in an owner that will fail at execution time with:
--   "The operation cannot be started by an account that uses SQL Server
--    Authentication. Start the operation with an account that uses
--    Integrated Authentication."
--
-- Fix: if no explicit @(JobOwner) was supplied, fall back to 'sa' (a
-- Windows/Integrated-style principal for job-ownership purposes) instead of
-- letting it default to the connecting SQL-auth login.
-- #############################################################################
IF (@job_owner IS NULL)
BEGIN
    SET @job_owner = N'sa';
    PRINT 'No explicit job owner supplied. Defaulting job owner to [sa] to avoid SQL Authentication execution error.';
END

-- Build the ISSERVER command from parameters so it always matches
-- whatever was actually deployed by deploy_ssis.sql
SET @ssis_command =
    N'/ISSERVER "\"\SSISDB\' + @ssis_folder + N'\' + @ssis_project + N'\' + @ssis_package + N'\"" '
    + N'/SERVER ' + @server_name + N' '
    + N'/ENVREFERENCE ' + CAST(@env_reference_id AS nvarchar(20)) + N' '
    + N'/Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 '
    + N'/Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True '
    + N'/CALLERINFO SQLAGENT /REPORTING E';

BEGIN TRY

    BEGIN TRANSACTION;

    -- Drop the job by name if it already exists (idempotent, unlike
    -- deleting by a hardcoded job_id GUID)
    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
    BEGIN
        PRINT 'Existing job [' + @job_name + '] found. Dropping it.';
        EXEC msdb.dbo.sp_delete_job @job_name = @job_name, @delete_unused_schedule = 1;
    END

    -- Verify the target owner login actually exists before we try to use it,
    -- so a typo'd/removed JobOwner fails fast with a clear message instead of
    -- an obscure sp_add_job error.
    IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @job_owner)
    BEGIN
        RAISERROR (N'Job owner login [%s] does not exist on this server.', 16, 1, @job_owner);
    END

    -- Ensure the operator exists; skip notification wiring if it doesn't
    -- rather than failing the whole deploy
    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = @operator_name)
    BEGIN
        PRINT 'WARNING: Operator [' + @operator_name + '] does not exist. Job will be created without failure email notification.';
    END

    EXEC @ReturnCode = msdb.dbo.sp_add_job
        @job_name                     = @job_name,
        @enabled                      = @job_enabled,
        @notify_level_eventlog        = 2,
        @notify_level_email           = 2,
        @notify_level_netsend         = 0,
        @notify_level_page            = 0,
        @delete_level                 = 0,
        @description                  = N'Runs SSIS ETL package to load Timesheet data',
        @category_name                = N'[Uncategorized (Local)]',
        @owner_login_name             = @job_owner,
        @notify_email_operator_name   = @operator_name,
        @job_id                       = @jobId OUTPUT;
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;

    EXEC @ReturnCode = msdb.dbo.sp_add_jobstep
        @job_id               = @jobId,
        @step_name             = N'Run SSIS Package',
        @step_id                = 1,
        @cmdexec_success_code  = 0,
        @on_success_action     = 1,
        @on_success_step_id    = 0,
        @on_fail_action        = 2,
        @on_fail_step_id       = 0,
        @retry_attempts        = 0,
        @retry_interval        = 0,
        @os_run_priority       = 0,
        @subsystem              = N'SSIS',
        @command                = @ssis_command,
        @database_name          = N'master',
        @flags                  = 0;
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;

    EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1;
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;

    EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule
        @job_id                  = @jobId,
        @name                     = N'Recurring ETL Load',
        @enabled                 = 1,
        @freq_type                = 4,      -- daily
        @freq_interval            = 1,
        @freq_subday_type         = 2,      -- seconds
        @freq_subday_interval     = 30,
        @freq_relative_interval   = 0,
        @freq_recurrence_factor   = 0,
        @active_start_date        = 20260702,
        @active_end_date          = 20270228,
        @active_start_time        = 70000,
        @active_end_time          = 235959;
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;

    EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)';
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;

    COMMIT TRANSACTION;
    PRINT 'Job [' + @job_name + '] created successfully with owner [' + @job_owner + '].';
    GOTO EndSave;

QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;
    RAISERROR (N'Failed to create SQL Agent job [%s].', 16, 1, @job_name);

EndSave:

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

    DECLARE @err_msg nvarchar(4000) = ERROR_MESSAGE();
    PRINT 'ERROR: ' + @err_msg;
    RAISERROR (@err_msg, 16, 1);

END CATCH
GO