--Create Database
if db_id('DB-Cloud-Tunnels-LM') IS NULL
create database [DB-Cloud-Tunnels-LM]
go

use [DB-Cloud-Tunnels-LM]
go

--Creating Table
drop table if exists tblTest;

create table tblTest(
ID int not null,
FirstName nvarchar(20),
LastName nvarchar(20),
Position varchar(20)
);
go

-- Inserting Data
Insert into tblTest (ID, FirstName, LastName, Position)
Values (1, 'Lwazisile', 'Mhlambi', 'First')

--Creating a Server Side Login
use master
go

if not exists (SELECT * FROM sys.server_principals WHERE name = 'SQLDeploy')
create login SQLDeploy with Password = 'Guest123';
go

--Creating a Database User
use [DB-Cloud-Tunnels-LM]
go

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'automation_user')
Create user automation_user for login SQLDeploy;
go

--Setting Permissions
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Role_automated')
create role Role_automated;

grant select, insert on schema::dbo to Role_automated

alter role Role_automated add member automation_user