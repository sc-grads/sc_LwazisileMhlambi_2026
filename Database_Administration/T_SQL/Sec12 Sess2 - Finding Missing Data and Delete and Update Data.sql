-----------------------------------------------------------
--Missing Data
select E.EmployeeNumber as ENumber, E.EmployeeFirstName, E.EmployeeLastName,
T.EmployeeNumber as TNumber, sum(T.Amount) as TotalAmount
from tblEmployee as E
left join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where T.EmployeeNumber is null
group by E.EmployeeNumber, T.EmployeeNumber, 
E.EmployeeFirstName, E.EmployeeLastName
order by E.EmployeeNumber, T.EmployeeNumber, 
E.EmployeeFirstName, E.EmployeeLastName

---Dervied Table
select *
from (
select E.EmployeeNumber as ENumber, E.EmployeeFirstName, E.EmployeeLastName,
T.EmployeeNumber as TNumber, sum(T.Amount) as TotalAmount
from tblEmployee as E
right join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
--where T.EmployeeNumber is null
group by E.EmployeeNumber, T.EmployeeNumber, E.EmployeeFirstName, 
E.EmployeeLastName
) as newTable
where ENumber is null
order by ENumber, TNumber, 
EmployeeFirstName,EmployeeLastName

-----------------------------------------------------------
--Deleting Data
begin transaction

select count(*) from tblTransaction

delete  tblTransaction
from tblEmployee as E
right join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
where E.EmployeeNumber is null

select count(*) from tblTransaction

rollback transaction

select count(*) from tblTransaction
----------------

begin transaction

select count(*) from tblTransaction

delete tblTransaction
from tblTransaction
where EmployeeNumber in(
select TNumber
from (
select E.EmployeeNumber as ENumber, E.EmployeeFirstName, E.EmployeeLastName,
T.EmployeeNumber as TNumber, sum(T.Amount) as TotalAmount
from tblEmployee as E
right join tblTransaction as T
on E.EmployeeNumber = T.EmployeeNumber
--where T.EmployeeNumber is null
group by E.EmployeeNumber, T.EmployeeNumber, E.EmployeeFirstName, 
E.EmployeeLastName
) as newTable
where ENumber is null
--order by ENumber, TNumber, 
--EmployeeFirstName,EmployeeLastName
)
select count(*) from tblTransaction

rollback transaction

select count(*) from tblTransaction

-----------------------------------------------------------
--Updating Data
select * from tblEmployee where EmployeeNumber = 194
select * from tblTransaction where EmployeeNumber = 3
select * from tblTransaction where EmployeeNumber = 194

begin tran
--select * from tblTransaction where EmployeeNumber = 194

update tblTransaction
set EmployeeNumber = 194
output inserted.EmployeeNumber, deleted.EmployeeNumber
from tblTransaction
where EmployeeNumber in (3, 5, 7, 9)

--select * from tblTransaction where EmployeeNumber = 194
rollback tran