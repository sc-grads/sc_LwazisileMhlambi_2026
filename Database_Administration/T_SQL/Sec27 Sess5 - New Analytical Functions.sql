--First_Value and Last_Value
--Takes first and last value of partition
--SQL window functions used to retrieve the first or last value from a sorted 
--partition of data without requiring complex self-joins

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
first_value(NumberAttendance)
over(partition by E.EmployeeNumber order by A.AttendanceMonth) as FirstMonth,
last_value(NumberAttendance)
over(partition by E.EmployeeNumber order by A.AttendanceMonth) as LastMonth
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber

-----------------------------------------------------------
--LAG and Lead
--Lag goes backwards and Lead goes forwards

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
lag(NumberAttendance, 3)
over(partition by E.EmployeeNumber order by A.AttendanceMonth) as myLag,
lead(NumberAttendance, 3)
over(partition by E.EmployeeNumber order by A.AttendanceMonth) as myLead
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber

-----------------------------------------------------------
--CUME_DIST and PERCENT_RANK
--CUME_DIST (Cumulative Distribution): It calculates the cumulative distribution 
---of a value in a set. This means it gives the proportion of rows with a value 
---less than or equal to that specified value.

--PERCENT_RANK: It also provides a ranking but does so based on the number of rows 
---before the specified value. It calculates the rank of a row as a percentage of 
---the total number of rows.

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
cume_dist() over(partition by E.EmployeeNumber 
				 order by A.AttendanceMonth) as MyCume_Dist,
Percent_Rank() over(partition by E.EmployeeNumber 
					order by A.AttendanceMonth) as MyPercent_Rank
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber

-----------------------------------------------------------
--Percentile_Cont and Percentile_Disc

--Percentile_Cont (Continuous Percentile)
---This function considers the data as a continuous range and interpolates 
---values to find the percentile. If you request the 50th percentile (or median), 
---it may return a value that is not explicitly in the dataset.

--PERCENTILE_DISC (Discrete Percentile):
---In contrast, this function returns the closest actual value from the dataset 
---without interpolation.

select distinct EmployeeNumber,
Percentile_Cont(0.5) within group (order by NumberAttendance) 
					 Over (Partition by EmployeeNumber) as AverageCont,
Percentile_Disc(0.5) within group (order by NumberAttendance) 
					 Over (Partition by EmployeeNumber) as AverageDisc
from tblAttendance

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
cume_dist() over(partition by E.EmployeeNumber 
				 order by A.AttendanceMonth) as MyCume_Dist,
Percent_Rank() over(partition by E.EmployeeNumber 
					order by A.AttendanceMonth) as MyPercent_Rank
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber