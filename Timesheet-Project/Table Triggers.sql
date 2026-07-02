Use [Timesheet-DB]
Go

------ tblConsultant ----
CREATE OR ALTER TRIGGER trg_tblConsultant_Update
ON tblConsultant
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM inserted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsUpdated, PerformedBy)
    VALUES ('tblConsultant', 'UPDATE', 'SUCCESS', 'Rows updated in tblConsultant', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

CREATE OR ALTER TRIGGER trg_tblConsultant_Delete
ON tblConsultant
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM deleted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsDeleted, PerformedBy)
    VALUES ('tblConsultant', 'DELETE', 'SUCCESS', 'Rows deleted from tblConsultant', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

------ tblClient ----
CREATE OR ALTER TRIGGER trg_tblClient_Update
ON tblClient
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM inserted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsUpdated, PerformedBy)
    VALUES ('tblClient', 'UPDATE', 'SUCCESS', 'Rows updated in tblClient', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

CREATE OR ALTER TRIGGER trg_tblClient_Delete
ON tblClient
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM deleted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsDeleted, PerformedBy)
    VALUES ('tblClient', 'DELETE', 'SUCCESS', 'Rows deleted from tblClient', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

------ tblLeave ----
CREATE OR ALTER TRIGGER trg_tblLeave_Update
ON tblLeave
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM inserted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsUpdated, PerformedBy)
    VALUES ('tblLeave', 'UPDATE', 'SUCCESS', 'Rows updated in tblLeave', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

CREATE OR ALTER TRIGGER trg_tblLeave_Delete
ON tblLeave
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM deleted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsDeleted, PerformedBy)
    VALUES ('tblLeave', 'DELETE', 'SUCCESS', 'Rows deleted from tblLeave', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

------ tblExpenseClaim ----
CREATE OR ALTER TRIGGER trg_tblExpenseClaim_Update
ON tblExpenseClaim
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM inserted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsUpdated, PerformedBy)
    VALUES ('tblExpenseClaim', 'UPDATE', 'SUCCESS', 'Rows updated in tblExpenseClaim', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

CREATE OR ALTER TRIGGER trg_tblExpenseClaim_Delete
ON tblExpenseClaim
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM deleted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsDeleted, PerformedBy)
    VALUES ('tblExpenseClaim', 'DELETE', 'SUCCESS', 'Rows deleted from tblExpenseClaim', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO


-- ---- tblTimesheetEntries ----
CREATE OR ALTER TRIGGER trg_tblTimesheetEntries_Update
ON tblTimesheetEntries
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM inserted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsUpdated, PerformedBy)
    VALUES ('tblTimesheetEntries', 'UPDATE', 'SUCCESS', 'Rows updated in tblTimesheetEntries', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO

CREATE OR ALTER TRIGGER trg_tblTimesheetEntries_Delete
ON tblTimesheetEntries
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM deleted);

    INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, RowsDeleted, PerformedBy)
    VALUES ('tblTimesheetEntries', 'DELETE', 'SUCCESS', 'Rows deleted from tblTimesheetEntries', @RowsAffected, @RowsAffected, SUSER_SNAME())
END
GO