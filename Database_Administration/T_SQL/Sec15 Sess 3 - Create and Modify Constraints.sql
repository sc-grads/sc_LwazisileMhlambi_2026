-----------------------------------------------------------
--What are Constraints
insert into tblEmployee
select NULL, EmployeeFirstname, EmployeeMiddleName, EmployeeLastName, 
EmployeeGovernmentID, DateOfBirth, Department
from tblEmployee

insert into tblEmployee
values (2001, 'FirstName', 'M', 'LastName', 'AB123456C', '1994-01-01', 'Commercial'),
(null, 'AnotherFirstName', 'N', 'AnotherLastName', 'AB1234567C', '1994-01-02', 'Finance')

--Constraints will stop the insertion as we specified not null for EmployeeID

-----------------------------------------------------------
--Unique Constraints - What are They?

--These stop the entering of duplicate values
--However stop the insertion of NULL multiple values

-----------------------------------------------------------
--Unique Constraints in Action
alter table tblEmployee
add constraint unqGovernmentID UNIQUE (EmployeeGovernmentID)

--Checking for duplicate governmentIDs
select EmployeeGovernmentID, count(EmployeeGovernmentID) as MyCount
from tblEmployee
group by EmployeeGovernmentID
having count(EmployeeGovernmentID) > 1

--Checking for duplicate rows
select * from tblEmployee where EmployeeGovernmentID in ('HN513777D', 'TX593671R ')

--Deleting the duplicate rows (test using rollback)
begin tran
delete top(2) from tblEmployee
where EmployeeNumber in (131, 132)

select * from tblEmployee where EmployeeGovernmentID in ('HN513777D', 'TX593671R ')

rollback tran

--Committing Transaction
begin tran
delete top(2) from tblEmployee
where EmployeeNumber in (131, 132)

select * from tblEmployee where EmployeeGovernmentID in ('HN513777D', 'TX593671R ')

commit tran

--Adding another constraint
alter table tblTransaction
add constraint unqTransaction unique (Amount, DateOfTransaction, EmployeeNumber)

delete from tblTransaction
where EmployeeNumber = 131

insert into tblTransaction
values (1, '2015-01-01', 131)
insert into tblTransaction
values (1, '2015-01-01', 131)

--Remove Constraint
alter table tblTransaction
Drop constraint unqTransaction

--Creating a table with constraints defined
create table tblTransaction2 (
Amount smallmoney not null,
DateOfTransaction smalldatetime not null,
EmployeeNumber int not null,
Constraint unqTransaction2 Unique (Amount, DateOfTransaction, EmployeeNumber))

--Dropping the table
drop table tblTransaction2

-----------------------------------------------------------
--Default Constraints - What are They?
--Replacement for a Null at the time of creating a column

-----------------------------------------------------------
--Default Constraints in Action

alter table tblTransaction
add DateOfEntry datetime

alter table tblTransaction
add constraint defDateOfEntry Default GetDate() for DateOfEntry;

delete from tblTransaction where EmployeeNumber < 3

insert into tblTransaction (Amount, DateOfTransaction, EmployeeNumber)
values (1, '2014-01-01', 1)
insert into tblTransaction (Amount, DateOfTransaction, EmployeeNumber, DateOfEntry)
values (2, '2014-01-01', 1, '2013-01-01')

select * from tblTransaction where EmployeeNumber < 3

--Creating Table with Default Constraint
create table tblTransaction2 (
Amount smallmoney not null,
DateOfTransaction smalldatetime not null,
EmployeeNumber int not null,
DateOfEntry datetime null constraint tblTransaction2_defDateOfEntry Default getdate())

insert into tblTransaction2 (Amount, DateOfTransaction, EmployeeNumber)
values (1, '2014-01-01', 1)
insert into tblTransaction2 (Amount, DateOfTransaction, EmployeeNumber, DateOfEntry)
values (2, '2014-01-01', 1, '2013-01-01')

select * from tblTransaction2 where EmployeeNumber < 3

drop table tblTransaction2

alter table tblTransaction
drop constraint defDateOfEntry

alter table tblTransaction
drop column DateOfEntry

-----------------------------------------------------------
--Check Constraint - What are They?
-- Limits row entry based on specific criteria

-----------------------------------------------------------
--Check Constraints - in Practice
alter table tblTransaction
add constraint chkAmount check (Amount > -1000 and Amount < 1000)

insert into tblTransaction
values (1010, '2014-01-01', 1)

--Alterting Middlename Column to not allow fullstops
alter table tblEmployee with nocheck --does not check existing rows
add constraint chkMiddleName check
(Replace(EmployeeMiddleName, '.','') = EmployeeMiddleName or 
EmployeeMiddleName is null)

alter table tblEmployee
drop constraint chkMiddleName

begin tran
insert into tblEmployee
values (2003, 'A', 'B', 'C', 'D', '2014-01-01', 'Accounts')
select * from tblEmployee where EmployeeNumber = 2003
rollback tran

--Adding Constraint to limit the year of birth
alter table tblEmployee with nocheck
add constraint chkDateOfBirth check (DateOfBirth between '1900-01-01' and getdate())

begin tran
insert into tblEmployee
values (2003, 'A', 'B', 'C', 'D', '2115-01-01', 'Accounts')
select * from tblEmployee where EmployeeNumber = 2003
rollback tran

--Creating Table with Check constraint
Create table tblEmployee2 (
EmployeeMiddleName varchar(50) null constraint CK_EmployeeMiddleName check
(Replace(EmployeeMiddleName, '.','') = EmployeeMiddleName or EmployeeMiddleName is null))

drop table tblEmployee2

alter table tblEmployee
drop chkDateOfBirth
alter table tblEmployee
drop chkMiddleName
alter table tblTransaction
drop chkAmount

-----------------------------------------------------------
--Primary Key
-- Similar to the Unique constraint
-- However does not allow nulls
-- It clusteres a table and sorts the table
-- Only one per table

-----------------------------------------------------------
--Primary Key - In Practice
alter table tblEmployee
add constraint PK_tblEmployee Primary Key (EmployeeNumber)

insert into tblEmployee (EmployeeNumber, EmployeeFirstName, EmployeeMiddleName, 
EmployeeLastName, EmployeeGovernmentID, DateofBirth, Department)
values (2004, 'FirstName', 'MiddleName', 'LastName','AB12345FI', '2014-01-01', 
'Accounts')

delete from tblEmployee
where EmployeeNumber = 2004

alter table tblEmployee
drop constraint PK_tblEmployee

create table tblEmployee2 (
EmployeeNumber int constraint PK_tblEmployee2 Primary Key Identity (1,1), --autonumber
EmployeeName nvarchar(20))

insert into tblEmployee2
values ('My Name'), ('My Name')

select * from tblEmployee2

delete from tblEmployee2

truncate table tblEmployee2 --wipes memory

--Inserting explicit rows
insert into tblEmployee2
values (3, 'My Name'), (4,'My Name')

set identity_insert tblEmployee2 on

insert into tblEmployee2(EmployeeNumber, EmployeeName)
values (38, 'My Name'), (39, 'My Name')

set identity_insert tblEmployee2 off

drop table tblEmployee2

select @@IDENTITY
Select scope_identity()

Select ident_current('dbo.tblEmployee2')

-----------------------------------------------------------
--Foreign Key - What is it?
-- Opposite of a primary
-- References the specific row
-- Uses a primary key or unique constraint to SEEK the value
-- Can be null
-- No action, Cascade, Set Null, Set Default

-----------------------------------------------------------
--Foreign Key - In Practice


alter table tblTransaction with nocheck
add constraint FK_tblTransaction_EmployeeNumber Foreign Key(EmployeeNUmber)
References tblEmployee (EmployeeNumber)

Begin tran
alter table tblTransaction alter column EmployeeNumber int null
alter table tblTransaction add constraint DF_tblTransaction Default 124 for EmployeeNumber
alter table tblTransaction with nocheck
add constraint FK_tblTransaction_EmployeeNumber foreign key (EmployeeNumber)
References tblEmployee(EmployeeNumber)
On Update Cascade --Updates both primary and secondary key
On Delete No Action
--set null set default

update tblEmployee set EmployeeNumber = 9123 where EmployeeNumber = 123


Select E.EmployeeNumber, T.*
from tblEmployee E join
tblTransaction T on
E.EmployeeNumber = T.EmployeeNumber
where T.Amount IN (-179.47, 786.22, -967.36, 957.03)

rollback tran