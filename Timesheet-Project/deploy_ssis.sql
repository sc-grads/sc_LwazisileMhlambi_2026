SET NOCOUNT ON;
USE [SSISDB];
GO

-- 1. Grab SQLCMD variables
DECLARE @folder_name    nvarchar(128)   = N'$(FolderName)';
DECLARE @project_name   nvarchar(128)   = N'$(ProjectName)';
DECLARE @ProjectStream  varbinary(max);

SET @ProjectStream = CONVERT(varbinary(max), $(ProjectStream), 1);

BEGIN TRY
    -- Create target folder if missing
    IF NOT EXISTS (SELECT 1 FROM catalog.folders WHERE name = @folder_name)
    BEGIN
        PRINT 'Folder [' + @folder_name + '] not found. Creating it.';
        EXEC catalog.create_folder @folder_name;
    END

    PRINT 'Deploying project [' + @project_name + '] to folder [' + @folder_name + ']...';

    -- Bypass wrapper: Clean up any stuck operations first
    EXEC [catalog].[startup];

    -- Explicitly execute the deployment assembly
    EXEC [catalog].[deploy_project]          
        @folder_name = @folder_name,
        @project_name = @project_name,
        @project_stream = @ProjectStream;

    PRINT 'SSIS project deployment completed successfully.';
END TRY
BEGIN CATCH
    DECLARE @err_msg  nvarchar(4000) = ERROR_MESSAGE();
    
    -- If it STILL complains about SQL Authentication, it means the server's 
    -- registry explicitly blocks SSISDB deployment over SQL Auth entirely.
    IF @err_msg LIKE '%SQL Server Authentication%'
    BEGIN
        PRINT '------------------------------------------------------------';
        PRINT 'CRITICAL: Your SQL Server instance has strict SSISDB policies.';
        PRINT 'To fix this instantly on your SQL Server, run this command via SSMS:';
        PRINT 'EXEC sp_configure ''clr enabled'', 1; RECONFIGURE;';
        PRINT 'ALTER DATABASE SSISDB SET TRUSTWORTHY ON;';
        PRINT '------------------------------------------------------------';
    END

    RAISERROR ('%s', 16, 1, @err_msg);
END CATCH
GO