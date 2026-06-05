--Synonyms
--Another identifier of the object/ table
--No need to have the table at the time of creation

select * from sys.objects

create synonym EmployeeTable
for tblEmployee
go

-----------------------------------------------------------
--Dynamic SQL
-- SQL can be written and executed in different forms which could result to sql injection
--Therefore it is crucial to write complex SQL queries which will safeguard from that

select * from tblEmployee where EmployeeNumber = 129
go

declare @command as varchar(225);
set @command =  'select * from tblEmployee where EmployeeNumber = 129'
execute (@command);
go

declare @command as varchar(225), @param as varchar(50);
set @command =  'select * from tblEmployee where EmployeeNumber = '
set @param = '129 or 1=1'
execute (@command + @param); --sql injection
go

declare @command as varchar(225), @param as varchar(50);
set @command =  N'select * from tblEmployee where EmployeeNumber = @ProductID'
set @param = N'129'
execute sys.sp_executesql @statement = @command, @params = N'@ProductID int', @ProductID = @param;
go
