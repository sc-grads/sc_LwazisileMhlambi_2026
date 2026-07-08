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

DECLARE @folder_name    nvarchar(128)   = N'$(FolderName)';
DECLARE @project_name   nvarchar(128)   = N'$(ProjectName)';
DECLARE @project_stream varbinary(max)  = $(ProjectStream);

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

    EXEC catalog.deploy_project
        @folder_name    = @folder_name,
        @project_name   = @project_name,
        @project_stream = @project_stream;

    COMMIT TRANSACTION;

    PRINT 'SSIS project deployment completed successfully.';

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @err_msg  nvarchar(4000) = ERROR_MESSAGE();
    DECLARE @err_num  int            = ERROR_NUMBER();
    DECLARE @err_line int            = ERROR_LINE();

    PRINT 'ERROR deploying SSIS project.';
    PRINT 'Error Number: ' + CAST(@err_num AS nvarchar(20));
    PRINT 'Error Line: ' + CAST(@err_line AS nvarchar(20));
    PRINT 'Error Message: ' + @err_msg;

    -- Force sqlcmd to exit non-zero so the GitHub Actions step fails
    RAISERROR (@err_msg, 16, 1);

END CATCH
GO