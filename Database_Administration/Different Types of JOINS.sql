Select * From Student

Select * From Course

Select s.rollno, s.studentname, c.courseid 
from student s 
join course c
on s.rollno = c.rollno

--------------------------------------------
Select s.rollno, s.studentname, c.courseid 
from student s 
left join course c
on s.rollno = c.rollno

--------------------------------------------

Select s.rollno, s.studentname, c.courseid 
from student s 
right join course c
on s.rollno = c.rollno

--------------------------------------------

Select s.rollno, s.studentname, c.courseid 
from student s 
full join course c
on s.rollno = c.rollno