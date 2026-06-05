--Scalar Functions


create function AmountPlusOne(@Amount smallmoney)
Returns smallmoney
As
Begin
		Return  @Amount + 1

End
go

select DateOfTransaction, EmployeeNumber, Amount, dbo.AmountPlusOne(Amount) as AmountAndOne
from tblTransaction

declare @myVal smallmoney
exec @myVal = dbo.AmountPlusOne @Amount = 345.67
select @myVal
go
-----------------------------------------------------------
--A more complicated scalar function

create function numTrans(@EmployeeNumber int)
returns int
as
begin
	Declare @NumberOfTransactions int
	Select @NumberOfTransactions = count(*) from tblTransaction
	where EmployeeNumber = @EmployeeNumber
	return @NumberOfTransactions
end

select *, dbo.numTrans(EmployeeNumber) as TransNum
from tblEmployee
go

-----------------------------------------------------------
--Inline Table Function


CREATE FUNCTION TransList (@EmployeeNumber int)
    
RETURNS TABLE AS RETURN
(
    SELECT * From tblTransaction
	where EmployeeNumber = @EmployeeNumber
)

select *
from dbo.TransList(123)
go
-----------------------------------------------------------
--Multi-statement Table Function


CREATE FUNCTION TransList2 (@EmployeeNumber int)
Returns @Translist2 Table
(Amount smallmoney,
DateOfTransaction smalldatetime
EmployeeNumber int)
AS
Begin
Return
End

-----------------------------------------------------------
--Apply
--Useful for joining functions and tables

Select * from dbo.TransList(123)
go

select * , (select count(*) from dbo.TransList(E.EmployeeNumber)) as NumTransactions
from tblEmployee as E

select * 
from tblEmployee as E
outer apply TransList(E.EmployeeNumber) as T
    
--Outer apply - all of tblEmployee, UDF 0+ rows
---Eqvl to left join

--Cross apply - UDF 1+ rows
---Eqvl to inner join

select * 
from tblEmployee as E
where (select count(*) from dbo.TransList(E.EmployeeNumber)) >3

