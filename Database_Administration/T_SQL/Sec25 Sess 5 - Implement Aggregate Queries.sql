-----------------------------------------------------------
--Introduction

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance
from tblEmployee as E join tblAttendance  as A
on E.EmployeeNumber = A.EmployeeNumber

-----------------------------------------------------------
--Over()
--Calculates total sum over the entirety of the table
-- Takes a range of rows and does a calculation based on the number over the rows

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
sum(A.NumberAttendance) over() as TotalAttendance
from tblEmployee as E join tblAttendance  as A
on E.EmployeeNumber = A.EmployeeNumber
group by A.EmployeeNumber, year(A.AttendanceMonth)

-----------------------------------------------------------
--Partition By and Order By
--Partition by refines the range or rows used, to make a discrete section
---Reduces the sum over each row
---Breaks down according to the number rows

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
sum(A.NumberAttendance) over(partition by A.EmployeeNumber, year(A.AttendanceMonth) order by A.AttendanceMonth) as RunningTotal
--convert(decimal(7,4), A.NumberAttendance) / sum(A.NumberAttendance) over(partition by A.EmployeeNumber) * 100.0000 AS PercentageAttendance
from tblEmployee as E join tblAttendance  as A
on E.EmployeeNumber = A.EmployeeNumber
where A.AttendanceMonth < '20150101'

-----------------------------------------------------------
--Rows Between

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
sum(A.NumberAttendance) 
over(partition by A.EmployeeNumber, year(A.AttendanceMonth) 
	 order by A.AttendanceMonth
	 rows between 1 preceding and 1 following ) as RunningTotal
from tblEmployee as E join tblAttendance  as A
on E.EmployeeNumber = A.EmployeeNumber
--where A.AttendanceMonth < '20150101'
order by A.EmployeeNumber, A.AttendanceMonth

-----------------------------------------------------------
--Current Row and Unbounded
---Instead of specifying rows between, you can use unbounded (entirety)
--- Current Row is the same as 0 preceding or following

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
sum(A.NumberAttendance) 
over(partition by A.EmployeeNumber, year(A.AttendanceMonth) 
	 order by A.AttendanceMonth
	 rows between current row and unbounded following ) as RunningTotal
from tblEmployee as E join tblAttendance  as A
on E.EmployeeNumber = A.EmployeeNumber
--where A.AttendanceMonth < '20150101'
order by A.EmployeeNumber, A.AttendanceMonth

-----------------------------------------------------------
--Range vs Rows
---Difference between rows and range:
---Rows: We take the current row and work out the back and forwards from that row
---Range: We take the current row and look at the partition and the order
	   -- and treat anything that has the same order as being a tie
	   -- Only supported with Unbounded and Current Row
	   -- Takes ties into account when determining which rows to take
select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
sum(A.NumberAttendance) 
over(partition by A.EmployeeNumber, year(A.AttendanceMonth) 
	 order by A.AttendanceMonth
	 rows between unbounded preceding and current row) as RowsTotal,

sum(A.NumberAttendance) 
over(partition by A.EmployeeNumber, year(A.AttendanceMonth) 
	 order by A.AttendanceMonth
	 range between unbounded preceding and current row) as RangeTotal

from tblEmployee as E join 
(select * from tblAttendance UNION all select * from tblAttendance) as A
on E.EmployeeNumber = A.EmployeeNumber
--where A.AttendanceMonth < '20150101'
order by A.EmployeeNumber, A.AttendanceMonth

-----------------------------------------------------------
--Omitting Range/Row?

--Default when there is no order by:
---rows between unbounded preceding and unbounded following 
---range between unbounded preceding and unbounded following

--Default when there is an order by:
---range between unbounded preceding and current row

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
sum(A.NumberAttendance) 
over() as TotalAttendance
from tblEmployee as E join tblAttendance  as A
on E.EmployeeNumber = A.EmployeeNumber
