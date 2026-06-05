--Re-introducing Query Plans

select * from tblEmployee

-----------------------------------------------------------
--Heaps and Scans

--Head: list of rows connected to each other via an IAM (index allocation map)
--Scan: go through the entire table

--Heaps are used when structures are not created, adding huge amounts of data for processing

-----------------------------------------------------------
--B-Tree

--Balance Tree
--- Allows index to be in order
--- Increases the speed of retreiving data

-----------------------------------------------------------
--Clustered Indexes

-- Like an Index of a Book
-- Can use primary keys to create a clustered index
-- Does not require unique values when creating

create clustered index ind_tblEmployee
on tblEmployee (EmployeeNumber)

drop index ind_tblEmployee
on tblEmployee

select * from tblEmployee --scan -> goes through entire table

select * from tblEmployee where EmployeeNumber = 127  --seek 


alter table tblEmployee
add constraint pk_tblEmployee Primary Key (EmployeeNumber)

-----------------------------------------------------------
--Non-Clustered Indexes

--Additional indexes
--Creates an order index but does not reorder the table
--Can be created on multiple fields

create nonclustered index idx_tblEmployee_DateOfBirth on tblEmployee(DateOfBirth)
create nonclustered index idx_tblEmployee_DateOfBirth_Department ON tblEmployee(DateOfBirth, Department)

select * from tblEmployee
where DateOfBirth >= '1992-01-01' and DateOfBirth < '1993-01-01'

-----------------------------------------------------------
--Filtered Indices

--Can increase query performance and plan quality
--Reduces maintenance costs
--Reduces storage costs

select EmployeeLastName
from tblEmployee
where Department = 'HR'

create nonclustered index idx_LastNameForHR
on tblEmployee(EmployeeLastName) where Department = 'HR' -- Filtered Index

-----------------------------------------------------------
--Include

create nonclustered index idx_LastNameForHR
on tblEmployee(EmployeeNumber)
include (EmployeeFirstName, EmployeeMiddleName, EmployeeLastName) --Includes additional items

