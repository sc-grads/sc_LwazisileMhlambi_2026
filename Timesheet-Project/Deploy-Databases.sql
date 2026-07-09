DROP DATABASE IF EXISTS [Timesheet-DB-LM];
CREATE DATABASE [Timesheet-DB-LM]
GO

USE [Timesheet-DB-LM]
GO


--Creating Staging Table
drop table if exists tblStagingTimesheet

CREATE TABLE tblStagingTimesheet (
StagingID INT IDENTITY(1,1) PRIMARY KEY,
ConsultantName NVARCHAR(255),
DateValue NVARCHAR(255),
DOfWeek NVARCHAR(255),
Client NVARCHAR(255),
ClientProjectName NVARCHAR(255),
WorkDescription NVARCHAR(max),
BillableFlag NVARCHAR(255),
Comments NVARCHAR(max),
TotalHours NVARCHAR(255),
StartTime NVARCHAR(255),
EndTime NVARCHAR(255),
SheetName VARCHAR(255),
FilePath TEXT,
LoadedAt DATETIME DEFAULT GETDATE()
);
GO

--Creating Consultant Table
drop table if exists tblConsultant;

create table tblConsultant (
ConsultantID Int Identity(1,1) Primary Key,
FullName NVARCHAR(255) NOT NULL,
FirstName NVARCHAR(255),
LastName NVARCHAR(255)
);
GO


-- Creating Client Table
drop table if exists tblClient;

create table tblClient (
ClientID Int Identity(1,1) Primary Key,
ClientName NVARCHAR(255) NOT NULL

);
GO

--Creating Timesheet Entries Table (Final)
drop table if exists tblTimesheetEntries

create table tblTimesheetEntries (
TimesheetID int identity(1,1) Primary Key,
ConsultantID int not null,
WorkDate date not null,
ClientID int not null,
ClientProjectName varchar(255),
WorkDescription varchar(max),
BillableFlag varchar(50),
Comments varchar(max),
StartTime Time,
EndTime Time,
MinutesWorked Int Check(MinutesWorked >= 0),

ImportDate DATETIME DEFAULT GETDATE(),
UpdatedAt DATETIME NULL,
IsDeleted BIT      NOT NULL CONSTRAINT DF_tblTimesheetEntries_IsDeleted DEFAULT 0,
DeletedAt DATETIME NULL,
RowSeq INT NULL,

    CONSTRAINT FK_TimesheetEntries_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID),

    CONSTRAINT FK_TimesheetEntries_Client
        FOREIGN KEY (ClientID)
        REFERENCES tblClient(ClientID)
);
GO

--Creating Timesheet Table 
drop table if exists tblTimesheet

create table tblTimesheet (
TimesheetID int identity(1,1) Primary Key,
SourceTimesheetID int null,
ConsultantID int not null,
WorkDate date not null,
ClientID int not null,
ClientProjectName varchar(255),
WorkDescription varchar(max),
BillableFlag varchar(50),
Comments varchar(max),
StartTime Time,
EndTime Time,
MinutesWorked Int Check(MinutesWorked >= 0),

ImportDate DATETIME DEFAULT GETDATE(),
UpdatedAt DATETIME NULL,

CONSTRAINT FK_Timesheet_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID),

 CONSTRAINT FK_Timesheet_Client
        FOREIGN KEY (ClientID)
        REFERENCES tblClient(ClientID),

CONSTRAINT FK_Timesheet_TimesheetEntry
        FOREIGN KEY (SourceTimesheetID)
        REFERENCES tblTimesheetEntries(TimesheetID)
);

CREATE NONCLUSTERED INDEX IX_Timesheet_SourceTimesheetID
ON tblTimesheet (SourceTimesheetID);

GO


--Creating Audit Log Table
drop table if exists tblAuditLog

CREATE TABLE tblAuditLog (
AuditID INT IDENTITY(1,1) PRIMARY KEY,
TableName NVARCHAR(255),
Action NVARCHAR(50),
StatusCode NVARCHAR(50),
StatusMessage NVARCHAR(255),
RowsAffected INT,
PerformedAt DATETIME DEFAULT GETDATE(),
PerformedBy NVARCHAR(128) DEFAULT SUSER_SNAME(),
RowsInserted INT NOT NULL CONSTRAINT DF_tblAuditLog_RowsInserted DEFAULT 0,
RowsUpdated  INT NOT NULL CONSTRAINT DF_tblAuditLog_RowsUpdated  DEFAULT 0,
RowsDeleted  INT NOT NULL CONSTRAINT DF_tblAuditLog_RowsDeleted  DEFAULT 0,
);
GO


-- Creating Leave Table
drop table if exists tblLeave

create table tblLeave (
LeaveID int identity(1,1) primary key,
ConsultantID int not null,
Date date,
DayOfWeek nvarchar(255),
LeaveType NVARCHAR(255),
Comments NVARCHAR(255),
CONSTRAINT FK_Leave_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID)
);
GO

--Creating Expense Claim Staging Table
drop table if exists tblExpenseStaging;

create table tblExpenseStaging (
ExpenseStagingID Int Identity(1,1) Primary Key,
ConsultantName NVARCHAR(255),
Date NVARCHAR(255),
Month NVARCHAR(255),
ExpenseDescription NVARCHAR(255),
Type NVARCHAR(255),
Cost NVARCHAR(255),
SheetName VARCHAR(255),
FilePath VARCHAR(255),
LoadedAt DATETIME DEFAULT GETDATE()
);
GO

--Creating Expense Claim Table
drop table if exists tblExpenseClaim

create table tblExpenseClaim (
ClaimID int identity(1,1) primary key,
ConsultantID int not null,
Date date,
Month nvarchar(255),
ExpenseDescription NVARCHAR(255),
Type NVARCHAR(255),
Cost Float,
CONSTRAINT FK_ExpenseClaim_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID)
);
GO