;WITH Backfill AS (
    SELECT
        RowSeq,
        ROW_NUMBER() OVER (
            PARTITION BY ConsultantID, WorkDate,
                         ISNULL(StartTime, '00:00:00'), ISNULL(EndTime, '00:00:00')
            ORDER BY TimesheetID   
        ) AS NewRowSeq
    FROM tblTimesheetEntries
    WHERE IsDeleted = 0
)
UPDATE Backfill SET RowSeq = NewRowSeq;
GO