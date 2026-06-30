CREATE OR ALTER PROCEDURE usp_InsertNewConsultants
    @PerformedBy NVARCHAR(128) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @PerformedBy IS NULL
        SET @PerformedBy = SUSER_SNAME();

    DECLARE @RowsInserted INT

    INSERT INTO tblConsultant (FullName, FirstName, LastName)
    SELECT DISTINCT 
        ConsultantName,
        LEFT(ConsultantName, CHARINDEX(' ', ConsultantName) - 1),
        RIGHT(ConsultantName, LEN(ConsultantName) - CHARINDEX(' ', ConsultantName))
    FROM tblStagingTimesheet
    WHERE ConsultantName IS NOT NULL
    AND ConsultantName NOT IN (SELECT FullName FROM tblConsultant)

    SET @RowsInserted = @@ROWCOUNT

    IF @RowsInserted > 0
        INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, PerformedBy)
        VALUES ('tblConsultant', 'INSERT', 'SUCCESS', 'New consultants inserted from staging table', @RowsInserted, @PerformedBy)
    ELSE
        INSERT INTO tblAuditLog (TableName, Action, StatusCode, StatusMessage, RowsAffected, PerformedBy)
        VALUES ('tblConsultant', 'INSERT', 'NO ACTION', 'No new consultants to insert, all already exist', 0, @PerformedBy)
END