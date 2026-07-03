USE msdb;
GO

SET NOCOUNT ON;

DECLARE @alert_name             sysname        = N'$(AlertName)';
DECLARE @job_name               sysname        = N'$(JobName)';
DECLARE @operator_name          sysname        = N'$(OperatorName)';
DECLARE @notification_message   nvarchar(512)  = N'$(NotificationMessage)';
DECLARE @delay_between_responses int           = CAST('$(DelayBetweenResponses)' AS int);
DECLARE @message_id             int            = CAST('$(MessageId)' AS int);
DECLARE @severity               int            = CAST('$(Severity)' AS int);

DECLARE @ReturnCode INT = 0;

BEGIN TRY

    BEGIN TRANSACTION;

    -- The job must already exist (deploy_job.sql runs before this step),
    -- but fail fast with a clear message if it doesn't rather than
    -- letting sp_add_alert throw an opaque error.
    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
    BEGIN
        RAISERROR (N'Cannot create alert [%s]: job [%s] does not exist. Deploy the job first.', 16, 1, @alert_name, @job_name);
    END

    -- Drop the alert by name if it already exists (idempotent, same
    -- pattern as the job drop-and-recreate in deploy_job.sql)
    IF EXISTS (SELECT 1 FROM msdb.dbo.sysalerts WHERE name = @alert_name)
    BEGIN
        PRINT 'Existing alert [' + @alert_name + '] found. Dropping it.';
        EXEC msdb.dbo.sp_delete_alert @name = @alert_name;
    END

    -- Ensure the operator exists; skip notification wiring if it doesn't
    -- rather than failing the whole deploy
    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = @operator_name)
    BEGIN
        PRINT 'WARNING: Operator [' + @operator_name + '] does not exist. Alert will be created without email notification.';
    END

    EXEC @ReturnCode = msdb.dbo.sp_add_alert
        @name                       = @alert_name,
        @message_id                 = @message_id,
        @severity                   = @severity,
        @enabled                    = 1,
        @delay_between_responses    = @delay_between_responses,
        @notification_message       = @notification_message,
        @job_name                   = @job_name;
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = @operator_name)
    BEGIN
        EXEC @ReturnCode = msdb.dbo.sp_add_notification
            @alert_name      = @alert_name,
            @operator_name   = @operator_name,
            @notification_method = 1;  -- Email
        IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;
    END

    COMMIT TRANSACTION;
    PRINT 'Alert [' + @alert_name + '] created successfully.';
    GOTO EndSave;

QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;
    RAISERROR (N'Failed to create SQL Agent alert [%s].', 16, 1, @alert_name);

EndSave:

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

    DECLARE @err_msg nvarchar(4000) = ERROR_MESSAGE();
    PRINT 'ERROR: ' + @err_msg;
    RAISERROR (@err_msg, 16, 1);

END CATCH
GO