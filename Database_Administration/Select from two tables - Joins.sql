select * from [dbo].[Employee]

select * from [dbo].[Sales]

select * 
from [dbo].[Employee] e 
join Sales s
on e.empname = s.empname

select * 
from [dbo].[Employee] e 
join Sales s
on e.empid = s.empid