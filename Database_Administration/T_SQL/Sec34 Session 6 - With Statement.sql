--WITH Statement

with tblRank as
(select D.Department, EmployeeNumber, EmployeeFirstName, EmployeeLastName,
	   rank() over(partition by D.Department order by E.EmployeeNumber) as TheRank
from tblDepartment as D
		join tblEmployee as E on D.Department = E.Department),
Transaction2014 as
(select * from tblTransaction where DateOfTransaction < '2015-01-01')

select * from tblRank
left join Transaction2014
on tblRank.EmployeeNumber = Transaction2014.EmployeeNumber
where TheRank <= 5
order by Department, tblRank.EmployeeNumber

-----------------------------------------------------------
--Generating a List of Numbers

select * from tblEmployee as E
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber is null
order by E.EmployeeNumber

select * from tblTransaction
order by EmployeeNumber asc

with Numbers as (
select top(select max(EmployeeNumber) from tblTransaction) ROW_NUMBER() over (order by (select null)) as RowNumber
from tblTransaction as U)

select U.RowNumber from Numbers as U
left join tblTransaction as T
on u.RowNumber = T.EmployeeNumber
where T.EmployeeNumber is null
order by U.RowNumber

-----------------------------------------------------------
--Grouping Numbers

with Numbers as (
select top(select max(EmployeeNumber) from tblTransaction) ROW_NUMBER() over (order by (select null)) as RowNumber
from tblTransaction as U),
Transaction2014 as (
select * from tblTransaction where DateOfTransaction >= '2014-01-01' and DateOfTransaction < '2015-01-01'),

tblGap as(
select U.RowNumber, 
RowNumber - LAG(RowNumber) over(order by RowNumber) as PreviousRowNumber, 
Lead(RowNumber) over(order by RowNumber) - RowNumber as NextRowNumber,
case when RowNumber - LAG(RowNumber) over(order by RowNumber) = 1 then 0 else 1 end as GroupGap
from Numbers as U
left join tblTransaction as T
on u.RowNumber = T.EmployeeNumber
where T.EmployeeNumber is null)

order by RowNumber