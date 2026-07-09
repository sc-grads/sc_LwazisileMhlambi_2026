SET NOCOUNT ON;

-- Ensure we are working inside the SSIS catalog database
USE [SSISDB];
GO

-- Force impersonation immediately using your local Windows account
EXECUTE AS LOGIN = 'SAMBE2025008\Lwazisile Mhlambi';
GO

-- Declare variables
DECLARE @folder_name    nvarchar(128)   = N'$(FolderName)';
DECLARE @project_name   nvarchar(128)   = N'$(ProjectName)';
DECLARE @ProjectStream  varbinary(max);

-- Convert the hex stream passed from your GitHub Actions workflow
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

    -- Revert back to the original connection login safely
    REVERT;

    PRINT 'SSIS project deployment completed successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Always revert context on failure to prevent security leaks
    REVERT;

    DECLARE @err_msg  nvarchar(4000) = ERROR_MESSAGE();
    PRINT 'ERROR deploying SSIS project.';
    RAISERROR ('%s', 16, 1, @err_msg);
END CATCH
GO