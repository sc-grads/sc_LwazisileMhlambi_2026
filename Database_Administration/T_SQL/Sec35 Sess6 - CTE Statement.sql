--Self-Join
begin tran
alter table tblEmployee
add Manager int
go
update tblEmployee
set Manager = ((EmployeeNumber-123)/10)+123
where EmployeeNumber > 123
select E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, E.Manager,
	   M.EmployeeNumber ManagerNumber, M.EmployeeFirstName ManagerName, M.EmployeeLastName, M.Manager
from tblEmployee as E
left join tblEmployee as M
on E.Manager = M.EmployeeNumber
rollback tran


-----------------------------------------------------------
--Recursive CTE

begin tran
alter table tblEmployee
add Manager int
go
update tblEmployee
set Manager = ((EmployeeNumber-123)/10)+123
where EmployeeNumber > 123;

with myTable as
(select EmployeeNumber, EmployeeFirstName, EmployeeLastName, 0 as BossLevel --Anchor
from tblEmployee
where Manager is null
union all --UNION ALL
select E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, M.BossLevel + 1 --Recursive
from tblEmployee E
join myTable M on
E.Manager = M.EmployeeNumber
) --Recursive CTE
select * from myTable
rollback tran
