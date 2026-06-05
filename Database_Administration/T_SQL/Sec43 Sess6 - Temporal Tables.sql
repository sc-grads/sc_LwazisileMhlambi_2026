--What are temporal tables

--These are tables that separately preserve history, 
--which also reflects different versions of tables.
--Furthermore, they capture the current validity period (Start and End)
--Useful for rollbacks incase mistakes were made


-----------------------------------------------------------
--Creating Temporal Tables

create table dbo.tblEmployeeTemporal(
EmployeeNumber int not null primary key clustered,
EmployeeFirstName varchar(50) not null,
EmployeeMiddleName varchar(50) null,
EmployeeLastName varchar(50) not null,
EmployeeGovernmentID char(10) not null,
DateOfBirth date not null,
Department varchar(19) null,
ValidFrom datetime2(2) Generated always as row start,
ValidTO datetime2(2) Generated always as row end,
Period for system_time (ValidFrom, ValidTo))
with (System_Versioning = On)

Insert Into dbo.tblEmployeeTemporal (
EmployeeNumber, EmployeeFirstName, EmployeeMiddleName, EmployeeLastName,
EmployeeGovernmentID, DateOfBirth, Department)

Values (123, 'Jane', Null, 'Zwillling', 'AB123456G', '1985-01-01', 'Customer Relations'),
(124, 'Carolyn', 'Andrea', 'Zimmerman', 'AB234578H', '1975-06-01', 'Commercial'),
(125, 'Jane', Null, 'Zabokritski', 'LU778728T', '1977-12-09', 'Commercial')


select * from tblEmployeeTemporal

update tblEmployeeTemporal set EmployeeLastName = 'Smith' where EmployeeNumber = 124
update tblEmployeeTemporal set EmployeeLastName = 'Albert' where EmployeeNumber = 124

-----------------------------------------------------------
--Dropping Temporal Tables, and Specifying History Table

USE [70-461 T-SQL]
GO

ALTER TABLE [dbo].[tblEmployeeTemporal] SET ( SYSTEM_VERSIONING = OFF  )
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmployeeTemporal]') AND type in (N'U'))
DROP TABLE [dbo].[tblEmployeeTemporal]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSSQL_TemporalHistoryFor_1022626686]') AND type in (N'U'))
DROP TABLE [dbo].[MSSQL_TemporalHistoryFor_1022626686]
GO

--

create table dbo.tblEmployeeTemporal(
EmployeeNumber int not null primary key clustered,
EmployeeFirstName varchar(50) not null,
EmployeeMiddleName varchar(50) null,
EmployeeLastName varchar(50) not null,
EmployeeGovernmentID char(10) not null,
DateOfBirth date not null,
Department varchar(19) null,
ValidFrom datetime2(2) Generated always as row start,
ValidTO datetime2(2) Generated always as row end,
Period for system_time (ValidFrom, ValidTo))
with (System_Versioning = On (HISTORY_TABLE = dbo.tblEmployeeHistory))

Insert Into dbo.tblEmployeeTemporal (
EmployeeNumber, EmployeeFirstName, EmployeeMiddleName, EmployeeLastName,
EmployeeGovernmentID, DateOfBirth, Department)

Values (123, 'Jane', Null, 'Zwillling', 'AB123456G', '1985-01-01', 'Customer Relations'),
(124, 'Carolyn', 'Andrea', 'Zimmerman', 'AB234578H', '1975-06-01', 'Commercial'),
(125, 'Jane', Null, 'Zabokritski', 'LU778728T', '1977-12-09', 'Commercial')

-----------------------------------------------------------
--Altering Existing Tables to Make them temporal tables

--TO convert existing tables into temp tables you need to add constraints that will add to
-- existing set of constraints (not null)
alter table tblEmployee
add
ValidFrom datetime2(2) Generated always as row start constraint def_ValidFrom Default sysutcdatetime(), 
ValidTO datetime2(2) Generated always as row end constraint def_ValidTo Default
															convert(datetime2(2), '9999-12-31 23:59:59'),
Period for system_time (ValidFrom, ValidTo)

select * from tblEmployee
alter table tblEmployee
set (System_Versioning = On (HISTORY_TABLE = dbo.tblEmployeeHistory2))

-----------------------------------------------------------
--Querying Temporal Table at a point in time

--Changes system time

select * from tblEmployeeTemporal
for system_time as of '2021-02-01' --Rollbacking time

-----------------------------------------------------------
--Querying Temporal Tables between a range of times

select * from tblEmployeeTemporal
from startdate to enddate
between startdate and enddate
contained in (startdate, enddate)