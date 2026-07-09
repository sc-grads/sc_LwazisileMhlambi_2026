SET NOCOUNT ON;
USE [SSISDB];
GO

DECLARE @folder_name    nvarchar(128)   = N'$(FolderName)';
DECLARE @project_name   nvarchar(128)   = N'$(ProjectName)';
DECLARE @ProjectStream  varbinary(max);

SET @ProjectStream = CONVERT(varbinary(max), $(ProjectStream), 1);

-- We will store the binary stream into a global temp table so the SQL Agent Job can read it
IF OBJECT_ID('tempdb..##SSIS_Deploy_Stream') IS NOT NULL 
    DROP TABLE ##SSIS_Deploy_Stream;

CREATE TABLE ##SSIS_Deploy_Stream (ProjectStream VARBINARY(MAX));
INSERT INTO ##SSIS_Deploy_Stream VALUES (@ProjectStream);

BEGIN TRY
    -- Create target folder if missing (SQL Auth CAN create folders, just can't deploy projects)
    IF NOT EXISTS (SELECT 1 FROM catalog.folders WHERE name = @folder_name)
    BEGIN
        PRINT 'Folder [' + @folder_name + '] not found. Creating it.';
        EXEC catalog.create_folder @folder_name;
    END

    -- Set up dynamic SQL Agent job to run as the Server Service Account
    DECLARE @job_name NVARCHAR(128) = N'SSIS_DevOps_Deploy_' + CAST(NEWID() AS NVARCHAR(50));
    
    EXEC msdb.dbo.sp_add_job @job_name = @job_name, @enabled = 1, @owner_login_name = N'sa';
    EXEC msdb.dbo.sp_add_jobserver @job_name = @job_name, @server_name = N'(local)';

    -- The job step copies the stream from the temp table and deploys it natively
    DECLARE @command NVARCHAR(MAX) = N'
        USE SSISDB;
        DECLARE @Stream VARBINARY(MAX);
        SELECT TOP 1 @Stream = ProjectStream FROM ##SSIS_Deploy_Stream;
        
        EXEC catalog.deploy_project  
            @folder_name = N''' + @folder_name + ''',
            @project_name = N''' + @project_name + ''',
            @project_stream = @Stream;
    ';

    EXEC msdb.dbo.sp_add_jobstep 
        @job_name = @job_name, 
        @step_name = N'Deploy Project', 
        @database_name = N'SSISDB',
        @command = @command, 
        @backend_method = 0;

    -- Start the job asynchronously
    PRINT 'Starting background deployment job...';
    EXEC msdb.dbo.sp_start_job @job_name = @job_name;

    -- Wait and monitor the job until it completes
    DECLARE @job_status INT = 4; -- 4 = Idle/Not running, but let's loop while it executes
    WHILE 1 = 1
    BEGIN
        WAITFOR DELAY '00:00:02';
        
        SELECT TOP 1 @job_status = ja.run_status
        FROM msdb.dbo.sysjobactivity jq
        JOIN msdb.dbo.sysjobs j ON jq.job_id = j.job_id
        LEFT JOIN msdb.dbo.sysjobhistory ja ON jq.job_history_id = ja.instance_id
        WHERE j.name = @job_name
        ORDER BY jq.start_execution_date DESC;

        -- Check if it completed (1 = Succeeded, 0 = Failed, 3 = Canceled)
        IF @job_status IN (0, 1, 3) BREAK;
    END

    -- Clean up the job
    EXEC msdb.dbo.sp_delete_job @job_name = @job_name;
    DROP TABLE ##SSIS_Deploy_Stream;

    IF @job_status = 1
        PRINT 'SSIS project deployment completed successfully via Agent bypass.';
    ELSE
    BEGIN
        RAISERROR('SQL Agent deployment job failed. Check SQL Server Agent Error Logs.', 16, 1);
    END

END TRY
BEGIN CATCH
    IF OBJECT_ID('tempdb..##SSIS_Deploy_Stream') IS NOT NULL DROP TABLE ##SSIS_Deploy_Stream;
    IF LOWER(@@VERSION) LIKE '%agent%' EXEC msdb.dbo.sp_delete_job @job_name = @job_name;
    
    DECLARE @err_msg nvarchar(4000) = ERROR_MESSAGE();
    RAISERROR ('%s', 16, 1, @err_msg);
END CATCH
GO