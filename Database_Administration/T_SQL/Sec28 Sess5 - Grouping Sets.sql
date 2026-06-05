--Adding Totals

select E.Department, E.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
--order by Department, EmployeeNumber, AttendanceMonth
UNION
select E.Department, E.EmployeeNumber, null, sum(A.NumberAttendance) as TotalAttendance
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by E.Department, E.EmployeeNumber
order by Department, EmployeeNumber

-----------------------------------------------------------
--Rollup, Grouping and Grouping_ID

--Rollup is used to create subtotals and grand totals in query results. 
---When you use ROLLUP in conjunction with the GROUP BY clause, it generates 
---additional summary rows that aggregate data at different levels of detail.

select E.Department, E.EmployeeNumber, null, sum(A.NumberAttendance) as TotalAttendance,
grouping ( E.EMployeeNumber) as EmployeeGroupedBy,
grouping_ID (E.EmployeeNumber) as EmployeeNumberGroupedID
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by rollup (E.Department, E.EmployeeNumber, A.AttendanceMonth)
order by Department, EmployeeNumber, AttendanceMonth

-----------------------------------------------------------
--Grouping Sets

-- allows you to define specific combinations of dimensions for 
---aggregation in your query results
---Enables you to specify multiple groupings explicitly within a single query
select E.Department, E.EmployeeNumber, null, sum(A.NumberAttendance) as TotalAttendance,
grouping ( E.EMployeeNumber) as EmployeeGroupedBy,
grouping_ID (E.Department, E.EmployeeNumber, A.AttendanceMonth) as EmployeeNumberGroupedID
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
group by grouping sets ((E.Department, E.EmployeeNumber, A.AttendanceMonth), (E.Department), ())
order by coalesce(Department, 'msuzo'), coalesce(E.EmployeeNumber, 99999), AttendanceMonth