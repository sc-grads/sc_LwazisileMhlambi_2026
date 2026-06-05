--The Where Clause

select * from tblTransaction as T
inner join tblEmployee as E
on E.EmployeeNumber = T.EmployeeNumber
where E.EmployeeLastName like 'y%'
order by T.EmployeeNumber

--Without using a join clause

select * from tblTransaction as T
where EmployeeNumber in 
	(select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

-----------------------------------------------------------
--Where and Not
--Not excludes the values in the subquery

select * from tblTransaction as T
where EmployeeNumber not in 
	(select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

-----------------------------------------------------------
--Any, Some and All

--any/some = OR
--all = AND

select * from tblTransaction as T
where EmployeeNumber <> all
	(select EmployeeNumber from tblEmployee where EmployeeLastName like 'y%')
order by EmployeeNumber

-----------------------------------------------------------
--From Clause

--Creating a derived table by using a sub query in the join


select * from tblTransaction as T
inner join (select * from tblEmployee 
where EmployeeLastName like 'y%') as E
on E.EmployeeNumber = T.EmployeeNumber
order by T.EmployeeNumber

-----------------------------------------------------------
--Select Clause

select E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, count(T.EmployeeNumber) as NumTransactions
from tblTransaction as T
inner join tblEmployee as E
on E.EmployeeNumber = T.EmployeeNumber
where E.EmployeeLastName like 'y%'
order by T.EmployeeNumber

--Using a subquery as an expression to bring one value/ column
select *, (select count(T.EmployeeNumber)
			from tblTransaction as T
			where T.EmployeeNumber = E.EmployeeNumber) as NumTransactions
from tblEmployee as E
where E.EmployeeLastName like 'y%' --correlated subquery

-----------------------------------------------------------
--Correlated Subquery - Where

select *
from tblTransaction as T
where exists
	(select EmployeeNumber from tblEmployee as E where EmployeeLastName like 'y%' 
		and T.EmployeeNumber = E.EmployeeNumber)
order by EmployeeNumber

-----------------------------------------------------------
--Top 5 from various categories

select * from
(select D.Department, EmployeeNumber, EmployeeFirstName, EmployeeLastName,
	   rank() over(partition by D.Department order by E.EmployeeNumber) as TheRank
from tblDepartment as D
		join tblEmployee as E on D.Department = E.Department) as MyTable
where TheRank <= 5
order by Department, EmployeeNumber

