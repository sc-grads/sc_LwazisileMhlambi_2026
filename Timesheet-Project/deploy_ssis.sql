SET NOCOUNT ON;

-- Ensure we are working inside the SSIS catalog database
USE [SSISDB];
GO

/* FIX: Conditional Impersonation. 
  Only impersonate if a specific deployment login variable is provided. 
  If empty, it will run as the connecting sqlcmd user.
*/
IF '$(DeployLogin)' <> '' AND '$(DeployLogin)' <> '$(DeployLogin' -- Catch uninitialized sqlcmd vars
BEGIN
    PRINT 'Impersonating login: $(DeployLogin)';
    EXECUTE AS LOGIN = '$(DeployLogin)';
END

-- Declare variables
DECLARE @folder_name    nvarchar(128)   = N'$(FolderName)';
DECLARE @project_name   nvarchar(128)   = N'$(ProjectName)';
DECLARE @ProjectStream  varbinary(max);

/* FIX: Read the hex stream directly from the sqlcmd variable 
  instead of searching for a local file path via OPENROWSET.
*/
SET @ProjectStream = CONVERT(varbinary(max), $(ProjectStream), 1);

BEGIN TRY
    BEGIN TRANSACTION;

    -- Create target folder if missing
    IF NOT EXISTS (SELECT 1 FROM catalog.folders WHERE name = @folder_name)
    BEGIN
        PRINT 'Folder [' + @folder_name + '] not found. Creating it.';
        EXEC catalog.create_folder @folder_name;
    END
    ELSE
    BEGIN
        PRINT 'Folder [' + @folder_name + '] already exists.';
    END

    -- Deploy the binary stream
    PRINT 'Deploying project [' + @project_name + '] to folder [' + @folder_name + ']...';

    EXEC SSISDB.catalog.deploy_project  
        @folder_name = @folder_name,
        @project_name = @project_name,
        @project_stream = @ProjectStream;

    COMMIT TRANSACTION;

    -- Clean up impersonation if it was used
    IF HAS_PERMS_BY_NAME(NULL, NULL, 'VIEW SERVER STATE') = 1 -- Quick context check
    BEGIN
        WHILE ORIGINAL_LOGIN() <> SYSTEM_USER
        BEGIN
            REVERT;
        END
    END

    PRINT 'SSIS project deployment completed successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Ensure context is reverted on error
    IF HAS_PERMS_BY_NAME(NULL, NULL, 'VIEW SERVER STATE') = 1
    BEGIN
        WHILE ORIGINAL_LOGIN() <> SYSTEM_USER
        BEGIN
            REVERT;
        END
    END

    DECLARE @err_msg  nvarchar(4000) = ERROR_MESSAGE();
    PRINT 'ERROR deploying SSIS project.';
    RAISERROR ('%s', 16, 1, @err_msg);
END CATCH
GO