--How to write a cursor

--Cursor - The use of row based opertions vs set-based operations
-- Goes at one row at a time

Declare @EmployeeID int
Declare csr cursor for 
select EmployeeNumber
from tblEMployee
where EmployeeNumber between 120 and 299

open csr
fetch next from csr into @EmployeeID
while @@FETCH_STATUS = 0
begin 
	select * from tblTransaction where EmployeeNumber = @EmployeeID
	fetch next from csr  into @EmployeeID
end
close csr
deallocate csr

-----------------------------------------------------------
--Disadvantages of Cursors

--Take a lot of time to query
--When to use a cursor? 

-----------------------------------------------------------
--Alternatives

--This is much faster than the cursor
select *
from tblTransaction T
right join tblEmployee E
on T.EmployeeNumber = E.EmployeeNumber
where E.EmployeeNumber between 120 and 299
and T.EmployeeNumber is not null

-----------------------------------------------------------
--Impact of scalar UDFs

--These tend to be swift at delivering results compared to using joins or detailed queries

-----------------------------------------------------------
--Combining Multiple DML Operations

--Merge -allows INSERT, UPDATE, DELETE in one operation
--Use of OR and AND in the Where Clause
--JOINS
--Procedures
