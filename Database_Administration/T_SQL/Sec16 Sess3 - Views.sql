--Creating Views
create view ViewByDepartment as 
select top(100) percent D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount as TotalAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber between 120 and 139
-- order by D.Department, T.EmployeeNumber - Does not work in view
go

select * from ViewByDepartment
go

create view ViewSummary as 
select D.Department, T.EmployeeNumber as EmpNum, sum(T.Amount) as TotalAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
group by D.Department, T.EmployeeNumber
--order by D.Department, T.EmployeeNumber
go

select * from ViewSummary
go

-----------------------------------------------------------
--Altering and Dropping Views
-- Can use the GUI interface to script as Alter

--alter view
alter view dbo.ViewByDepartment as 
select top(100) percent D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount as TotalAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber between 120 and 139
-- order by D.Department, T.EmployeeNumber - Does not work in view
go

if exists(select * from sys.views 
where [TABLE_NAME] = 'ViewByDepartment' and [TABLE_SCHEMA] = 'dbo') 
	drop view dbo.ViewByDepartment
go

select * from sys.views -- Viewing system views

-----------------------------------------------------------
--Securing Views

select V.name, S.text
from sys.syscomments as S
inner join sys.views as V
on S.id = V.object_id

select OBJECT_DEFINITION(objecti_id('dbo.ViewByDepartment'))
select * from sys.sql_modules

go

create view ViewByDepartment with encryption as --securing the view
select top(100) percent D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount as TotalAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber between 120 and 139
-- order by D.Department, T.EmployeeNumber - Does not work in view
go

-----------------------------------------------------------
-- Security

-- Views limit the user to access objects of a database
-- They serve as a safer option for data viewing and access

-----------------------------------------------------------
-- Adding New Rows to Views

begin tran

insert into ViewByDepartment (EmployeeNumber, DateOfTransaction, TotalAmount)
values (132, '2015-07-07', 999.99)

select * from ViewByDepartment order by Department, EmployeeNumber

rollback tran

--Updating Rows of a View

begin tran
--select  * from ViewByDepartment order by EmployeeNumber, DateOfTransaction
--select * from tblTransaction where EmployeeNumber in (132, 142)

update ViewByDepartment
set EmployeeNumber = 142
where EmployeeNumber = 132

select  * from ViewByDepartment order by EmployeeNumber, DateOfTransaction
--select * from tblTransaction where EmployeeNumber in (132, 142)

rollback tran

--Use WITH CHECK OPTION at the end of the view to limit the entry

-----------------------------------------------------------
-- Deleting Rows in Views
select * from ViewByDepartment
delete from ViewByDepartment
where TotalAmount = 999.99 and EmployeeNumber = 132
go

create view  ViewSimple as
select * from tblTransaction
go

begin tran
delete from ViewSimple
where EmployeeNumber = 132
select * from ViewSimple
rollback tran

-----------------------------------------------------------
--What is an Index

-- Indexes group entries like chapters in a book
--Seek is based on an index and are much faster than a scan
-- Indexed views are quite limited

-----------------------------------------------------------
--Creating an Indexed View

drop view ViewByDepartment
go
create view dbo.ViewByDepartment with schemabinding as 
select D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount as TotalAmount
from dbo.tblDepartment as D
inner join dbo.tblEmployee as E
on D.Department = E.Department
inner join dbo.tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber between 120 and 139
-- order by D.Department, T.EmployeeNumber - Does not work in view
go


Create Unique Clustered Index inx_ViewByDepartement on dbo.ViewByDepartment (EmployeeNumber, Department)
