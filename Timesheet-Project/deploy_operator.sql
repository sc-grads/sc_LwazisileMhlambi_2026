USE msdb;
GO

SET NOCOUNT ON;

DECLARE @operator_name   sysname        = N'$(OperatorName)';
DECLARE @email_address   nvarchar(100)  = N'$(EmailAddress)';
DECLARE @enabled         tinyint        = CAST('$(OperatorEnabled)' AS tinyint);

DECLARE @ReturnCode INT = 0;

BEGIN TRY

    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = @operator_name)
    BEGIN
        PRINT 'Existing operator [' + @operator_name + '] found. Updating it.';

        EXEC @ReturnCode = msdb.dbo.sp_update_operator
            @name           = @operator_name,
            @enabled        = @enabled,
            @email_address  = @email_address;
        IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;
    END
    ELSE
    BEGIN
        PRINT 'Operator [' + @operator_name + '] not found. Creating it.';

        EXEC @ReturnCode = msdb.dbo.sp_add_operator
            @name           = @operator_name,
            @enabled        = @enabled,
            @email_address  = @email_address;
        IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback;
    END

    COMMIT TRANSACTION;
    PRINT 'Operator [' + @operator_name + '] deployed successfully.';
    GOTO EndSave;

QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;
    RAISERROR (N'Failed to deploy SQL Agent operator [%s].', 16, 1, @operator_name);

EndSave:

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

    DECLARE @err_msg nvarchar(4000) = ERROR_MESSAGE();
    PRINT 'ERROR: ' + @err_msg;
    RAISERROR (@err_msg, 16, 1);

END CATCH
GO