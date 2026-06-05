--What are Triggers?
--- DML - Data Manipulation Language
--- DML Triggers FOR, AFTER, INSTEAD OF

-----------------------------------------------------------
--Creating an After Trigger

CREATE TRIGGER tr_tblDepartment
    ON dbo.tblDepartment
    After DELETE, INSERT, UPDATE
    AS
    BEGIN
    SET NOCOUNT ON --Afters the message (5 row(s) affected)
    END
    go

CREATE TRIGGER tr_tblTransaction
    ON dbo.tblTransaction
    After DELETE, INSERT, UPDATE
    AS
    BEGIN
    select * from inserted
    select * from deleted
    END
    GO

Begin tran
insert into tblTransaction (Amount, DateOfTransaction, EmployeeNumber)
values (123, '2015-07-10', 123)
Rollback Tran
Go

-----------------------------------------------------------
--Create an Instead of Trigger

alter Trigger tr_ViewByDepartment on dbo.ViewByDepartment
Instead of Delete
as
Begin
    declare @EmployeeNumber as int
    declare @DateOfTransaction as smalldatetime
    declare @Amount as smallmoney
    select @EmployeeNumber = EmployeeNumber, @DateOfTransaction = DateOfTransaction,
    @Amount = TotalAmount from deleted
--select *, 'ViewByDepartment' from deleted
    delete tblTransaction
    from tblTransaction as T
    where T.EmployeeNumber = @EmployeeNumber
    and T.DateOfTransaction = @DateOfTransaction
    and T.Amount = Amount
end
go

begin tran
select * from ViewByDepartment where TotalAmount = -2.77 and EmployeeNumber = 132
delete from ViewByDepartment
where TotalAmount = -2.77 and EmployeeNumber = 132
select * from ViewByDepartment where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran

-----------------------------------------------------------
--Nested Triggers
--@@NESTLEVEL - 0,1,2

alter trigger tr_tblTransaction
on tblTransaction
after delete, insert, update
as
begin
    if @@NESTLEVEL = 1
    begin
        select * from inserted
        select * from deleted
    end
end
go

begin tran
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
values (123, '2015-07-10', 123)
rollback tran

begin tran
select * from ViewByDepartment where TotalAmount = -2.77 and EmployeeNumber = 132
delete from ViewByDepartment
where TotalAmount = -2.77 and EmployeeNumber = 132
select * from ViewByDepartment where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran

exec sp_configure 'nested triggers';

exec sp_configure 'nested triggers',0;
reconfigure

-----------------------------------------------------------
--Update Functions

alter trigger tr_tblTransaction
on tblTransaction
after update
as
begin
    begin
    --if @@ROWCOUNT > 0
    --if update(DateOfTransaction)
    i--f COLUMNS_UPDATED() & 2 = 2
    begin
        select *,'Inserted - tblTransaction' from inserted
        select *, 'Deleted - tblTransaction' from deleted
    end
    end
end
go

update tblTransaction
set DateOfTransaction = '2015-07-12'
where Amount = 123 and DateOfTransaction = '2015-07-11' and EmployeeNumber = 123

begin tran
insert into tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
values (123, '2015-07-11', 123)
rollback tran

delete from tblTransaction
where Amount = 123 and EmployeeNumber = 123

begin tran
delete from ViewByDepartment
where TotalAmount = -2.77 and EmployeeNumber = 132
rollback tran

-----------------------------------------------------------
--Handling Mulitple Rows in a Session

alter Trigger tr_ViewByDepartment 
on dbo.ViewByDepartment
Instead of Delete
as
Begin
    select *, 'To be deleted' from deleted
    delete tblTransaction 
    from tblTransaction as T
    join Deleted as D
    on T.EmployeeNumber = D.EmployeeNumber
    and T.DateOfTransaction = D.DateOfTransaction
    and T.Amount = D.TotalAmount
end
go

begin tran
select *, 'Before Delete' from ViewByDepartment where EmployeeNumber = 132
delete from ViewByDepartment
where EmployeeNumber = 132 --and TotalAmount = 861.16
select *, 'After Delete' from ViewByDepartment where EmployeeNumber = 132
rollback tran