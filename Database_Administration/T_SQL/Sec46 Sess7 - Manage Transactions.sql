--What are Transactions
-- A series of Statements
--Follow ACID properties

-----------------------------------------------------------
--Implicit Transactions

select * from tblEmployee

-----------------------------------------------------------
--Explicit Transaction - Start and End Transactions

begin transaction

select * from tblEmployee

update tblEmployee
set EmployeeNumber = 123
where EmployeeNumber = 122

rollback transaction


select * from tblEmployee

-----------------------------------------------------------
--Mark a Transaction

--Giving transaction a name

begin tran myTrans with Mark

select * from tblEmployee

update tblEmployee
set EmployeeNumber = 123
where EmployeeNumber = 122

rollback tran myTrans


select * from tblEmployee

-----------------------------------------------------------
--Trancount

--Capture the level of transaction when nesting transaction
begin transaction

select @@TRANCOUNT
	begin tran

		update tblEmployee
		set EmployeeNumber = 123
		where EmployeeNumber = 122
		select @@TRANCOUNT
	Commit Tran
	select @@TRANCOUNT

commit transaction
select @@TRANCOUNT

select * from tblEmployee

-----------------------------------------------------------
--Scope and Type of Locks

--Shared Lock
---Allows concurrent transactions to read (Select)
---No other transactions can modify the data
---Released as soon as the read operation is completed

--Update Lock
---Used to prevent deadlock
---Transactions reading data- Shared Lock
---To update data, must convert to exclusive
---Cannot convert to Exclusive if there is a SHared lock
---Solution - Use Update lock, then convert to exclusive lock.

--Exclusive Locks
---Prevents access by concurrent transactions
--Used by Insert, Update, Delete

--Intent Locks
---Signal intent to place locks at a lower level
---Prevents other transactions from modifying higher level resources
---Detecting lock conflicts

-----------------------------------------------------------
--Locks in Practice, and the WAITFOR statement

begin tran
update tblEmployee set EmployeeNumber = 122 where EmployeeNumber = 123

waitfor delay '00:00:10'
rollback tran

-----------------------------------------------------------
--What would happen if locks did not exist?

--Lost Updates
--Uncommitted Dependency (dirty read)
--Inconsistent analysis (nonrepeatable read)
--Phantom reads
--Missing and double reads caused by row updates
--Missing one or more rows that were not the target of update

-----------------------------------------------------------
--What are Isolation levels?

--Dictate what locks are taken, for how long, and what happens

--5 Isolation Levels
---Read Committed - default iso level
---Read Uncommitted - dirty reads (uncommitted transactions)
---Repeatable Read 
---Snapshot
---Serialisable

-----------------------------------------------------------
--Isolation Levels in Action

--Read Committed - can only read what what has been committed

set transaction isolation level --snapshot
								--repeatable read
								--read committed
								--read uncommitted