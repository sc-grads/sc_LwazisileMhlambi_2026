--ROW_NUMBER, RANK, and DENSE_RANK

--When there is a tie, rank stays at the minimum, the next rank skips
--When there is tie, dense rank does not skip but repeat the rows  

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
ROW_NUMBER() over (partition by A.EMployeeNumber order by A.EmployeeNumber, A.AttendanceMonth) as RowNum,
Rank() Over(Partition by A.EmployeeNumber Order By A.EmployeeNumber, A.AttendanceMonth) as TheRank,
DENSE_RANK() over(partition by A.EmployeeNumber order by A.EmployeeNumber, A.AttendanceMonth) as TheDenseRnak
from tblEmployee as E join 
(select * from tblAttendance union all select * from tblAttendance) as A
on E.EmployeeNumber = A.EmployeeNumber

-----------------------------------------------------------
--NTILE
--Divides each partition into buckets

select A.EmployeeNumber, A.AttendanceMonth, A.NumberAttendance,
NTILE(10) over (partition by A.EMployeeNumber 
				   order by A.EmployeeNumber, A.AttendanceMonth) as TheNTile
from tblEmployee as E join tblAttendance as A
on E.EmployeeNumber = A.EmployeeNumber
where AttendanceMonth < '2015-05-01'