ALTER DATABASE [Timesheet-DB]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO


DROP DATABASE IF EXISTS [Timesheet-DB];
CREATE DATABASE [Timesheet-DB]
GO

USE [Timesheet-DB]
GO

--Creating Consultants Table
drop table if exists tblConsultants;

create table tblConsultants (
ConsultantID Int Identity(1,1) Primary Key,
FirstName varchar(50) not null,
LastName varchar(50) not null,
FullName AS (FirstName + ' ' + LastName),
CONSTRAINT UQ_ConsultantName UNIQUE(FirstName, LastName)

)

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

SourceFileName VARCHAR(255), --Captures the name of the file

ImportDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_TimesheetEntries_Consultant
        FOREIGN KEY (ConsultantID)
        REFERENCES tblConsultants(ConsultantID)
);


--Creating ImportedFiles Table
drop table if exists tblImportedFiles

create table tblImportedFiles (
FileID int Identity(1,1) Primary Key,
FileName varchar(255) Unique,
ConsultantID Int,
ImportedDate Datetime Default GetDate(),
RecordCount INT,
Status varchar(50),

CONSTRAINT FK_ImportedFiles_Consultant
    FOREIGN KEY(ConsultantID)
    REFERENCES tblConsultants(ConsultantID)
);

--Creatign ErrorLog Table
drop table if exists tblErrorLog

create table tblErrorLog (
ErrorID int Identity(1,1) Primary Key,
SourceFileName varchar(255),
ErrorDate DateTime Default GetDate(),
ErrorMessage varchar(max),
FailedData varchar(max)
);

--Creating Audit Log Table
drop table if exists tblAuditLog

create table tblAuditLog (
AuditID INT IDENTITY(1,1) PRIMARY KEY,
PackageName NVARCHAR(255),
TaskName NVARCHAR(255),
FilePath NVARCHAR(500),
SheetName NVARCHAR(255),
SheetType NVARCHAR(50),
RowsInserted INT,
RowsUpdated INT,
RowsDeleted INT,
StatusCode NVARCHAR(50),  -- SUCCESS, FAILURE, SKIPPED
ErrorMessage NVARCHAR(MAX),
ExecutionStart DATETIME,
ExecutionEnd DATETIME,
LoadedAt DATETIME DEFAULT GETDATE()
);

--Creating Staging Table
drop table if exists tblStagingTimesheet

CREATE TABLE tblStagingTimesheet (
StagingID INT IDENTITY(1,1) PRIMARY KEY,
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

drop table if exists tblStagingExpenseClaim

CREATE TABLE tblStagingExpenseClaim (
StagingID INT IDENTITY(1,1) PRIMARY KEY,
Mnth NVARCHAR(255),
ExpenseDescription NVARCHAR(255),
TypeDescription NVARCHAR(255),
ZarCost NVARCHAR(255),
SheetName VARCHAR(255),
FilePath TEXT,
LoadedAt DATETIME DEFAULT GETDATE()
);

drop table if exists tblStagingLeave

CREATE TABLE tblStagingLeave (
StagingID INT IDENTITY(1,1) PRIMARY KEY,
LeaveType NVARCHAR(255),
StartDate NVARCHAR(255),
EndDate NVARCHAR(255),
NumDays NVARCHAR(255),
SickNote NVARCHAR(255),
ApprovalObtained NVARCHAR(255),
SheetName VARCHAR(255),
FilePath TEXT,
LoadedAt DATETIME DEFAULT GETDATE()
);

drop table if exists tblStagingKey

CREATE TABLE tblStagingKey (
StagingID INT IDENTITY(1,1) PRIMARY KEY,
Client NVARCHAR(255),   
WorkType NVARCHAR(255),   
Description NVARCHAR(255),   
Resource NVARCHAR(255),   
Billable NVARCHAR(255),   
SheetName VARCHAR(255),
FilePath TEXT,
LoadedAt DATETIME DEFAULT GETDATE()
);

truncate table tblStagingTimesheet
truncate table tblStagingLeave
truncate table tblStagingExpenseClaim

select * from tblStagingTimesheet
select * from tblStagingLeave
select * from tblStagingExpenseClaim



