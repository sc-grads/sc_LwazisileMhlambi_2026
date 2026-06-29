USE msdb;
GO

EXEC sp_start_job @job_name = 'Timesheet ETL - Load Consultant and Client Data';
GO

DECLARE @job_status INT;
DECLARE @max_wait INT = 300;
DECLARE @elapsed INT = 0;

WAITFOR DELAY '00:00:05';

WHILE @elapsed < @max_wait
BEGIN
    SELECT @job_status = last_run_outcome
    FROM msdb.dbo.sysjobs j
    INNER JOIN msdb.dbo.sysjobservers js ON j.job_id = js.job_id
    WHERE j.name = 'Timesheet ETL - Load Consultant and Client Data';

    IF @job_status IN (0, 1, 3)
        BREAK;

    WAITFOR DELAY '00:00:05';
    SET @elapsed = @elapsed + 5;
END

IF @job_status = 1
    PRINT 'Job completed successfully.';
ELSE IF @job_status = 0
BEGIN
    PRINT 'Job failed.';
    RAISERROR('SSIS Job failed.', 16, 1);
END
ELSE
    PRINT 'Job status unknown or timed out.';
GO