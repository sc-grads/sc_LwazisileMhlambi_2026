--UNION and UNION ALL

--Criteria:
---Same number of columns
---Compatible data types

select * from inserted
union
select * from deleted

select convert(char(5), 'hi') as Greeting
union
select convert(char(11), 'hello there')
union
select convert(char(11), 'bonjour')
union all
select convert(char(11), 'hi') 

-- UNION will detect a duplicate and remove it
-- UNION ALL will allow the duplicate entry
-- Uses order of Precedence to join data sets

select convert(tinyint, 45) as MyCol
union
select convert(bigint,456)

select 'hi there'
union
select 4

-----------------------------------------------------------
--Intersect and Except
select *, ROW_NUMBER() over(order by (select null)) %3 as ShouldIDelete
into tblTransactionNew
from tblTransaction

delete from tblTransactionNew
where ShouldIDelete = 1

update tblTransactionNew
set DateOfTransaction = dateadd(day, 1, DateOfTransaction)
where ShouldIDelete = 2

alter table tblTransactionNew
drop column ShouldIDelete

select * from tblTransaction
intersect --except
select * from tblTransactionNew

--except shows all rows in table one except for those that exist in table 2
--intersect brings all that is common in table one and 2

-----------------------------------------------------------
--CASE Statement
declare @myOption as varchar(10) = 'Option B'

select case when @myOption = 'Option A' then 'First Option'
			when @myOption = 'Option B' then convert(varchar(10),2)--'Second Option'
			else 'No Option' END as MyOptions

--Uses order of precedence int will be first then str

-----------------------------------------------------------
-- isNULL and Coalesce

select * from tblEmployee where EmployeeMiddleName is null
--compares a variable to null

declare @myNullOption as varchar(10) = 'Option B'
select isnull(@myNullOption, 'No Option') as MyOptions
go

declare @myFirstOption as varchar(10) = 'Option A'
declare @mySecondOption as varchar(10) = 'Option B'

select coalesce(@myFirstOption, @mySecondOption, 'No Option') as MyOptions
go

select isnull ('ABC', 1) as MyAnswer
select coalesce ('ABC', 1) as MyOtherAnswer
go

select isnull (null, null) as MyAnswer
select coalesce (null, null) as MyOtherAnswer
go

create table tblExample
(myOption nvarchar(10) null)
go
insert into tblExample (myOption)
values ('Option A')

select coalesce (myOption, 'No Option') as MyOptions
into tblIsCoalesce
from tblExample

select coalesce (myOption, 'No Option') as MyOptions
into tblIsNull
from tblExample

drop table tblExample
drop table tblIsCoalesce
drop table tblIsNull

SELECT ISNULL([EmployeeMiddleName],'Blank') FROM [dbo].[tblEmployee] 
WHERE [EmployeeMiddleName] IS NULL

-----------------------------------------------------------
--Merge in Theory

--Involves bringing two tables together based on matching values
--Statements:
---WHEN MATCHED AND
---WHEN MATCHED THEN
---WHEN NOT MATCHED [BY SOURCE/ TARGET] THEN

-----------------------------------------------------------
--Let's Build our Merge Statement

Begin Tran
MERGE INTO tblTransaction as T --target table
USING (select EmployeeNumber, DateOfTransaction, sum(Amount) as Amount
from tblTransactionNew
group by EmployeeNumber, DateOfTransaction) as S-- source table
ON T.EmployeeNumber = S.EmployeeNumber and T.DateOfTransaction = S.DateOfTransaction
WHEN MATCHED THEN
	UPDATE SET Amount  = T.Amount + S.Amount
WHEN NOT MATCHED BY TARGET THEN 
	INSERT (Amount, DateOfTransaction, EmployeeNumber)
	VALUES (S.Amount, S.DateOfTransaction, S.EmployeeNumber)
OUTPUT inserted.*, deleted.*;
Rollback Tran

--Looking for rows with more than 1 entry

select EmployeeNumber, DateOfTransaction, sum(Amount) as TotalAmount
from tblTransactionNew
group by EmployeeNumber, DateOfTransaction
having count(*) > 1

--disable trigger name_of_trigger on table_name

-----------------------------------------------------------
--Merge with Additional Columns

Begin Tran
Alter Table tblTransaction
Add Comments varchar(50) null
go
MERGE INTO tblTransaction as T --target table
USING (select EmployeeNumber, DateOfTransaction, sum(Amount) as Amount
from tblTransactionNew
group by EmployeeNumber, DateOfTransaction) as S -- source table
ON T.EmployeeNumber = S.EmployeeNumber and T.DateOfTransaction = S.DateOfTransaction
WHEN MATCHED THEN
	UPDATE SET Amount  = T.Amount + S.Amount, Comments = 'Updated Row'
WHEN NOT MATCHED BY TARGET THEN 
	INSERT (Amount, DateOfTransaction, EmployeeNumber, Comments)
	VALUES (S.Amount, S.DateOfTransaction, S.EmployeeNumber, 'Inserted Row')
WHEN NOT MATCHED BY SOURCE THEN
	UPDATE SET Comments = 'Unchanged';
--OUTPUT inserted.*, deleted.*;
select * from tblTransaction order by EmployeeNumber, DateOfTransaction
Rollback Tran