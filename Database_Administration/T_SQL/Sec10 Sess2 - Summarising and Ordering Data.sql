-----------------------------------------------------------
--Summarising and Ordering Data
Select * from tblEmployee
where year(DateofBirth) between 1976 and 1986 -- DO NOT USE

Select year(Dateofbirth) as BirthYear, count(*) as NumberBorn
from tblEmployee
group by year(Dateofbirth)
--non-deterministic

Select year(Dateofbirth) as BirthYear, count(*) as NumberBorn
from tblEmployee
group by year(Dateofbirth)
order by year(DateofBirth) ASC --DESC

-----------------------------------------------------------
--Criteria on Summarised Data
select left(EmployeeLastName, 1) as Initial, count(*) as CountofInitial
from tblEmployee
group by left(EmployeeLastName, 1)
order by count(*) DESC --left(EmployeeLastName, 1)

select top(5) left(EmployeeLastName, 1) as Initial, count(*) as CountofInitial
from tblEmployee
group by left(EmployeeLastName, 1)
order by count(*) DESC --left(EmployeeLastName, 1)

select left(EmployeeLastName, 1) as Initial, count(*) as CountofInitial
from tblEmployee
group by left(EmployeeLastName, 1)
having count(*) >=50
order by count(*) DESC --left(EmployeeLastName, 1)

select left(EmployeeLastName, 1) as Initial, count(*) as CountofInitial
from tblEmployee
where DateofBirth > '19860101'
group by left(EmployeeLastName, 1)
having count(*) >=20
order by count(*) DESC

-----------------------------------------------------------
--Changing Blank Strings to Nulls
Update tblEmployee
Set EmployeeMiddleName = NULL
Where EmployeeMiddleName = ''

-----------------------------------------------------------
--Exercise
select datename(month, DateOfBirth) as MonthNumber, count(*) as NumberofEmployees,
datepart(month, DateOfBirth), count(EmployeeMiddleName) as NumberofMiddleNames,
count(*) - count(EmployeeMiddleName) as NoMiddleName,
format(min(DateOfBirth), 'dd-MM-YY') as EarliestDOB, 
format(max(DateofBirth), 'D') as LatestDOB
from tblEmployee
group by datename(month, DateOfBirth), datepart(month, DateOfBirth)
order by datepart(month, DateOfBirth)