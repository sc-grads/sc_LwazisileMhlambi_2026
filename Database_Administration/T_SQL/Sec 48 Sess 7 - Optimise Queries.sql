--What Are Statistics - Include Client Statistics

select * from tblEmployee E
left join tblDepartment D
on E.Department = D.Department

-----------------------------------------------------------
--The different types of joins and seeing HASH joins in action

--Different Join Types

--Hash Match
--Least effecient of the 3 joins

--Nested Loop Match - one small and one large table
--Merge Match - Larger table, sorted on join

select D.Department, D.DepartmentHead, E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName
from tblEmployee E
left join tblDepartment D
on E.Department = D.Department

-----------------------------------------------------------
--Nested Loops and Merge Joins in Action

select D.Department, D.DepartmentHead, E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName
from tblEmployee E
left join tblDepartment D
on E.Department = D.Department
where D.Department = 'HR'

--Merge joins work when same index scan is used on both tables
---Query optimisation using the right index (clustered/ nonclustered)

-----------------------------------------------------------
--Even Bigger Savings of Time When Using SARG

--Search Argument
--Can use indexes

--e.g Where PersoName like 'John%'

-----------------------------------------------------------
--Reading Query Plans and the cost of Sorting

--Viewing all the properties of the executed query
--Ordered version takes significant more time than the unordered version

-----------------------------------------------------------
--A mored advanced query plan

select EmployeeNumber, DateofTransaction, amount, sum(amount)
over(partition by EmployeeNumber order by DateOfTransaction) as totalamount
from tblTransaction

-----------------------------------------------------------
--Plan Guides

--When creating a 
--WITH RECOMPILE - Tells procedure to create a new plan guide when run

-----------------------------------------------------------
--Hints

--Hints instruct how the sql server engine how to run (overrides)
--WITH (FORCESEEK, FORCESCAN)

begin tran 
update tblEmployee
set Department = 'Commercial'
where EmployeeNumber = 130

--Likewise with joins (loop, merge and hash)
-- left loop/merge/hash join tblEmployee

-----------------------------------------------------------
--Statistics IO

set statistics io on 
go

-----------------------------------------------------------
--Set Showplan_All and Client Statistics

SET SHOWPLAN_ALL ON -- Will show in the results tab instead of the query

Set Statistics time on -- Will show CPU clock

-----------------------------------------------------------
--Dynamic vs Parameterised Queries

--Reviews SQL injection
--By using parameterised queries it set guadrails that will prevent from such
