SET NOCOUNT ON;

-- #############################################################################
-- FIX: catalog.folders / catalog.create_folder / catalog.deploy_project only
-- exist inside the SSISDB database. Without explicitly switching context here,
-- this script runs against whatever database the connection/sqlcmd -d opened
-- (e.g. master), and every catalog.* call fails with:
--   "Invalid object name 'catalog.folders'."
-- The reference workflow handles this by doing `USE [SSISDB];` before any
-- catalog calls -- this script was missing that statement entirely.
-- #############################################################################
USE [SSISDB];
GO

EXECUTE AS LOGIN = 'SAMBE2025008\Lwazisile Mhlambi';

DECLARE @folder_name    nvarchar(128)   = N'$(FolderName)';
DECLARE @project_name   nvarchar(128)   = N'$(ProjectName)';
DECLARE @ProjectStream varbinary(max);

SELECT @ProjectStream = BulkColumn
FROM OPENROWSET(BULK '$(ProjectPath)', SINGLE_BLOB) AS x;


BEGIN TRY

    BEGIN TRANSACTION;

    -- Create the target folder if it doesn't already exist
    IF NOT EXISTS (
        SELECT 1 FROM catalog.folders WHERE name = @folder_name
    )
    BEGIN
        PRINT 'Folder [' + @folder_name + '] not found. Creating it.';
        EXEC catalog.create_folder @folder_name;
    END
    ELSE
    BEGIN
        PRINT 'Folder [' + @folder_name + '] already exists.';
    END

    -- Deploy (or redeploy) the project. deploy_project overwrites
    -- an existing project of the same name in the same folder.
    PRINT 'Deploying project [' + @project_name + '] to folder [' + @folder_name + ']...';

    EXEC SSISDB.catalog.deploy_project
    @folder_name = N'$(FolderName)',
    @project_name = N'$(ProjectName)',
    @project_stream = @ProjectStream;

    COMMIT TRANSACTION;

    -- FIX: restore original execution context on success so the impersonation
    -- doesn't leak into whatever runs next on this session.
    REVERT;

    PRINT 'SSIS project deployment completed successfully.';

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- FIX: restore original execution context on the failure path too --
    -- without this, an impersonated session could remain impersonated
    -- even after the script errors out.
    REVERT;

    DECLARE @err_msg  nvarchar(4000) = ERROR_MESSAGE();
    DECLARE @err_num  int            = ERROR_NUMBER();
    DECLARE @err_line int            = ERROR_LINE();

    PRINT 'ERROR deploying SSIS project.';
    PRINT 'Error Number: ' + CAST(@err_num AS nvarchar(20));
    PRINT 'Error Line: ' + CAST(@err_line AS nvarchar(20));
    PRINT 'Error Message: ' + @err_msg;

    -- FIX: pass @err_msg as a %s argument instead of using it directly as the
    -- format string. RAISERROR treats its first argument as a printf-style
    -- format string, so a literal '%' inside the original SQL error message
    -- would otherwise break formatting or throw a separate RAISERROR error.
    -- Force sqlcmd to exit non-zero so the GitHub Actions step fails.
    RAISERROR ('%s', 16, 1, @err_msg);

END CATCH
GO