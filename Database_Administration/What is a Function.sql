select max(rate)
from HumanResources.EmployeePayHistory

select min(rate)
from HumanResources.EmployeePayHistory

select count(rate)
from HumanResources.EmployeePayHistory

select sum(rate)
from HumanResources.EmployeePayHistory

-------------------------------------------------
--Functions
print upper('dotnet')

print lower('dOtNet')

print convert(int, 15.56)

print getdate()

print day(getdate())

print month(getdate())

print year(getdate())

CREATE TABLE FunctionEmployee
(
	EmpID int Primary Key,
	FirstName varchar(50) NULL,
	LastName varchar(50) NULL,
	Salary int Null,
	Address varchar(50) null,
)

Insert into FunctionEmployee (EmpID, FirstName, LastName, Salary, Address)
Values (1, 'Bob', 'Dylan', 22000, 'Delhi'), 
	   (2, 'Ice', 'Cube', 15000, 'Compton'),
	   (3, 'Dr.', 'Dre', 20000, 'Inglewood')

select * from FunctionEmployee

create function fnGetEmpFullName
(@FirstName varchar(50), @LastName varchar(50))
returns varchar(101)
as
begin
return (select @FirstName + ' ' + @LastName)
end

select dbo.fnGetEmpFullName (FirstName, LastName) as FullName, Salary
from FunctionEmployee

create function fnGetEmployee()
returns table
as 
return (select * from FunctionEmployee)

select * from dbo.FunctionEmployee;

create function fnGetMulEmployee()
returns @Emp Table
(
Empid int,
FirstName varchar(50),
Salary int
)
as
begin
insert into @Emp select e.EmpID, e.FirstName, e.Salary
from FunctionEmployee e;

update @Emp set Salary = 25000 where EmpID = 1;

return
end

select * from dbo.fnGetMulEmployee()