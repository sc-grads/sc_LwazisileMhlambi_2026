----------------------------------------------------
--Creation of tblEmployee Table
create table tblEmployee 
(
EmployeeNumber int not null,
EmployeeFirstName varchar(50) not null,
EmployeeMiddleName varchar(50) null,
EmployeeLastName varchar(50) not null,
EmployeeGovernmentID char(10)null,
DateofBirth date not null
)

----------------------------------------------------
--Adding Additional Columns
Alter Table tblEmployee
Add Department varchar(10);

Insert Into tblEmployee
Values(132, 'Dylan', 'A', 'Word', 'HN513777D', '1992/09/14', 'Customer Relations')

Alter Table tblEmployee
Drop Column Department;

Alter Table tblEmployee
Add Department varchar(15);

Alter Table tblEmployee
ALter Column Department varchar(20);

Insert Into tblEmployee (EmployeeNumber, EmployeeFirstName, EmployeeMiddleName, 
EmployeeLastName, EmployeeGovernmentID, DateofBirth, Department)
Values(131, 'Jossef', 'H', 'Wright', 'TX593671R', '1971/12/24', 'Litigation')

-----------------------------------------------------------
--Selecting only part of a table - String
select * from tblEmployee
where EmployeeLastName <> 'Word'

select * from tblEmployee
where EmployeeLastName like '%W%'

select * from tblEmployee
where EmployeeLastName like '_W%' --w is a second letter

select * from tblEmployee
where EmployeeLastName like '[r-t]%'

select * from tblEmployee
where EmployeeLastName like '[^rst]%' --^ is the equivalent of not

-- % = 0 - infinity characters
-- _ = 1 character
-- [A-G] = In the range A-G
-- [AGQ] = A, G, or Q
-- [^AGQ] = NOT A, G or Q

select * from tblEmployee
where EmployeeLastName like '[%]%'

-----------------------------------------------------------
--Selecting only part of a table - numbers
select * from tblEmployee
where EmployeeNumber > 200

select * from tblEmployee
where not (EmployeeNumber > 200)

select * from tblEmployee
where EmployeeNumber != 200

select * from tblEmployee
where EmployeeNumber >= 200 and EmployeeNumber <=209

select * from tblEmployee
where not (EmployeeNumber >= 200 and EmployeeNumber <=209)

select * from tblEmployee
where EmployeeNumber < 200 or EmployeeNumber > 209

select * from tblEmployee
where EmployeeNumber between 200 and 209

select * from tblEmployee
where EmployeeNumber not between 200 and 209

select * from tblEmployee
where EmployeeNumber in (200,204,208)
