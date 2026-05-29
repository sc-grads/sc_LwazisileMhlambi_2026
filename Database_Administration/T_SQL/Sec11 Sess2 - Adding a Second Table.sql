-----------------------------------------------------------
--Adding a Second Table
create table tblTransaction 
(
Amount smallmoney not null,
DateOfTransaction smalldatetime null,
EmployeeNumber int not null
)

-----------------------------------------------------------
--Importing Data and Showing Tables Graphically
INSERT INTO tblTransaction VALUES
(-964.05, '20150526', 658), 
(-105.23, '20150914', 987), 
(-506.8, '20150505', 695)

Select * from tblTransaction

truncate table tblTransaction

-----------------------------------------------------------
--Writing a Join Query
select EmployeeNumber, sum (Amount) as TotalAmount
from tblTransaction
group by EmployeeNumber

select tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName, 
sum(Amount) as SumofAmount
from tblEmployee join
tblTransaction on 
tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName
order by EmployeeNumber

-----------------------------------------------------------
--Different Types of Join
select tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName, 
sum(Amount) as SumofAmount
from tblEmployee left join
tblTransaction on 
tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName
order by EmployeeNumber

select tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName, 
sum(Amount) as SumofAmount
from tblEmployee inner join
tblTransaction on 
tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by tblEmployee.EmployeeNumber, EmployeeFirstName, EmployeeLastName
order by EmployeeNumber

-----------------------------------------------------------
--Creatign a Third Table
select count(distinct Department)
from tblEmployee

----Derived Table
select count(Department) as NumberofDepartments
from
(Select Department, count(*) as NumberofDepartment
from tblEmployee
group by Department) as newTable

select distinct Department, convert(varchar(20), N'') as DepartmentHead
into tblDepartment
from tblEmployee

drop table tblDepartment

alter table tblDepartment
alter  column DepartmentHead varchar(30) null

-----------------------------------------------------------
--JOINing three tables
select tblDepartment.Department,DepartmentHead, Sum(Amount) as SumAmount
from tblDepartment
left join tblEmployee
on tblDepartment.Department = tblEmployee.Department
left join tblTransaction
on tblEmployee.EmployeeNumber = tblTransaction.EmployeeNumber
group by tblDepartment.Department, DepartmentHead
order by Department

insert into tblDepartment (Department, DepartmentHead)
values ('Accounts', 'James')

select D.DepartmentHead, sum(T.Amount) as SumAmount
from tblDepartment as D
left join tblEmployee as E
on D.Department = E.Department
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
group by D.DepartmentHead
order by D.DepartmentHead