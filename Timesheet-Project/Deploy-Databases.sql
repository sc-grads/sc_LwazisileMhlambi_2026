DROP DATABASE IF EXISTS [Timesheet-DB];
CREATE DATABASE [Timesheet-DB]
GO

USE [Timesheet-DB]
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

--Creating Consultant Table
drop table if exists tblConsultant;

create table tblConsultant (
ConsultantID Int Identity(1,1) Primary Key,
FullName NVARCHAR(255) NOT NULL,
FirstName NVARCHAR(255),
LastName NVARCHAR(255)

);

-- Creating Client Table
drop table if exists tblClient;

create table tblClient (
ClientID Int Identity(1,1) Primary Key,
ClientName NVARCHAR(255) NOT NULL,

);

--Creating Timesheet Table (Final)
drop table if exists tblTimesheetEntries

create table tblTimesheetEntries (
TimesheetID int identity(1,1) Primary Key,
ConsultantID int not null,
WorkDate date not null,
Client varchar(200),
ClientProjectName varchar(255),
WorkDescription varchar(max),
BillableFlag varchar(20),
Comments varchar(max),
StartTime Time,
EndTime Time,
TotalMinutes Int Check(TotalMinutes >= 0),

ImportDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_TimesheetEntries_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID)
);


--Creating Audit Log Table
drop table if exists tblAuditLog

CREATE TABLE tblAuditLog (
AuditID INT IDENTITY(1,1) PRIMARY KEY,
TableName NVARCHAR(255),
Action NVARCHAR(50),
StatusCode NVARCHAR(50),
StatusMessage NVARCHAR(255),
--RecordID INT,
--ConsultantName NVARCHAR(255),
RowsAffected INT,
PerformedAt DATETIME DEFAULT GETDATE()
);

-- Creating Leave Table
drop table if exists tblLeave

create table tblLeave (
LeaveID int identity(1,1) primary key,
ConsultantID int not null,
ConsultantName nvarchar(255),
Date date,
DayOfWeek nvarchar(255),
LeaveType NVARCHAR(255),
Comments NVARCHAR(255)
CONSTRAINT FK_Leave_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID)
);


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

--Creating Expense Claim Table
drop table if exists tblExpenseClaim

create table tblExpenseClaim (
ClaimID int identity(1,1) primary key,
ConsultantID int not null,
ConsultantName nvarchar(255),
Date date,
Month nvarchar(255),
ExpenseDescription NVARCHAR(255),
Type NVARCHAR(255),
Cost Float
CONSTRAINT FK_ExpenseClaim_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultant(ConsultantID)
);