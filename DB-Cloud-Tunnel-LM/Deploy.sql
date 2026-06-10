--Resetting the connections
ALTER DATABASE [DB-Cloud-Tunnels-LM]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO


DROP DATABASE IF EXISTS [DB-Cloud-Tunnels-LM];
CREATE DATABASE [DB-Cloud-Tunnels-LM]
GO

USE [DB-Cloud-Tunnels-LM]
GO

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
Values (1, 'Lwazisile', 'Mhlambi', 'First'),
		(1, 'Lwazisile', 'Mhlambi', 'Second');
GO

select * from tblTest