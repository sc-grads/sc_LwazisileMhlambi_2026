-----------------------------------------------------------
--The Problems with IDENTITY
--Can't insert into an existing column
--Numbers can't be reused especially with transactions
--Numbers are not removed when deleted

-----------------------------------------------------------
--GUIDs

--Globaly Unique Identifier 128 bit
--Changes with every input

declare @val as uniqueidentifier
set @val = NewID()
select @val as NewID
go

begin tran 
create table tblEmp4
(UniqueID uniqueidentifier constraint df_tblEmp4_UniqueID Default NewID(),
EmployeeNUmber int constraint uq_tblEmp4_EmployeeNumber unique)

Insert into tblEmp4(EmployeeNUmber)
values (1), (2), (3)
select * from tblEmp4
rollback tran
go

declare @val as uniqueidentifier
set @val = NEWSEQUENTIALID() -- Can be used only in a DEFAULT expression
select @val as TheNewID 
go

begin tran 
create table tblEmp4
(UniqueID uniqueidentifier constraint df_tblEmp4_UniqueID Default Newsequentialid() ,
EmployeeNUmber int constraint uq_tblEmp4_EmployeeNumber unique)

Insert into tblEmp4(EmployeeNUmber)
values (1), (2), (3)
select * from tblEmp4
rollback tran
go

-----------------------------------------------------------
--Creating Sequences
--Objects which store a number and give you the next number
--Can be inserted in many or no columns

Begin Tran
create sequence newSeq as bigint
start with 1
increment by 1
minvalue 1
maxvalue 999999
cycle
create sequence secondSeq as int
select * from sys.sequences
rollback tran

-----------------------------------------------------------
--Using Sequences

Begin Tran
create sequence newSeq as bigint
start with 1
increment by 1
minvalue 1
maxvalue 999999
cache 50
select next value for newSeQ as NextValue 
rollback tran

create sequence newSeq as bigint
start with 1
increment by 1
minvalue 1
--maxvalue 999999
cache 50


alter table tblTransaction
add NextNumber int Constraint DF_Transaction Default Next Value for newSeq

begin tran
select * from tblTransaction
Insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
Values (1, '2017-01-01', 123)
select * from tblTransaction where EmployeeNumber =123;
update tblTransaction
set NextNumber = next value for newSeq
where NextNumber is null
select * from tblTransaction --where EmployeeNumber = 123
rollback tran

alter sequence newSeq
restart with 1

alter table tblTransaction
drop DF_Transaction
alter table tblTransaction
drop column NextNumber
Drop Sequence newSeq