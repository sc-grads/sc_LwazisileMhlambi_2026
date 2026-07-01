select * from tblConsultant

select * from tblExpenseClaim
alter table tblExpenseClaim
drop column ConsultantName

select * from tblLeave
alter table tblLeave
drop column ConsultantName

select * from tblClient

select * from tblStagingTimesheet

select * from tblTimesheetEntries
where ClientID = 1
order by ImportDate Desc

ALTER TABLE tblTimesheetEntries ADD
    --IsDeleted BIT      NOT NULL CONSTRAINT DF_tblTimesheetEntries_IsDeleted DEFAULT 0,
    --DeletedAt DATETIME NULL,
    RowSeq    INT      NULL;
GO


select * from tblAuditLog
order by PerformedAt Desc


UPDATE tblAuditLog
SET PerformedBy = 'SAMBE2025008\Lwazisile Mhlambi'
WHERE PerformedBy IS NULL;

select sum(TotalMinutes)/60 as TotalHourse, C.FullName, TE.ConsultantID from tblTimesheetEntries TE
join tblConsultant C on TE.ConsultantID = C.ConsultantID
group by TE.ConsultantID, C.FullName



SELECT *
FROM tblExpenseStaging
WHERE [ExpenseDescription] IS NOT NULL
  AND [ExpenseDescription] <> 'Expense Description'
  AND [Date] IS NOT NULL
  AND [Type] IS NOT NULL
  AND [Cost] IS NOT NULL

select * from tblStagingTimesheet TST
join tblClient TC on 
TC.ClientName = TST.Client
Where Client = 'RMB'

select * from tblStagingTimesheet TST
where DateValue is not null


select distinct SheetName, ConsultantName from tblStagingTimesheet
order by ConsultantName

with CTE as (
select distinct SheetName, StagingID, ConsultantName, DateValue, DOfWeek, Client, ClientProjectName, 
WorkDescription, BillableFlag, Comments, TotalHours, StartTime, EndTime
from tblStagingTimesheet
where DateValue is not null
and WorkDescription is not null
and Comments <> 'Detailed Description of task(s) done'
and WorkDescription <> 'Public Holiday'
--and StartTime is null and EndTime is null
--order by StagingID asc
)

select * from CTE
select * from tblStagingTimesheet
--where ClientProjectName = 'Example'
where Comments <> 'Detailed Description of task(s) done'
and DateValue is not null
and WorkDescription is not null




truncate table tblAuditLog