--Creating an Employee Table
create table tblEmployee
(EmployeeNumber int,
EmployeeName int)

----------------------------
--Creating Temporary Variables
Declare @myvar as int = 2

Set @myvar = @myvar + 1

select @myvar as myVariable;

----------------------------
--Integer Numbers

--Bigint
--Int: Up to 2,000,000,000
--Smallint: -32767 to 32768
--Tinyint: 0 - 255

Declare @myvar2 as smallint = 2

Set @myvar2 = @myvar2 - 3

select @myvar2 as myVariable

--------------------------------
--Practice Activity 3 Solution
Declare @var as int = 200000
select @var

--------------------------------
--Non-integer Numbers
declare @var2 as decimal (7,2) -- or numeric (7,2) -layout (7 num, 2 decimal point)
set @var2 = 12345.67
select @var2 as myvar

declare @var3 as numeric (7) -- rounds to the nearest unit 
set @var3 = 12345.67
select @var3 as myvar

declare @var3 as numeric (10000000.12345678) -- uses 9 bytes of storage
set @var3 = 12345.67
select @var3 as myvar

declare @myvar4 as smallmoney = 123456.78917
select @myvar4 as myvar

declare @myfloat as float(24) = 123456.7891 -- as real
select @myfloat as myFloat

----------------------------------
--Mathematical Functions
Declare @mymath as numeric (7,2) = 3

Select Power(@mymath, 2)
select square(@mymath)
select power(@mymath, 0.5)
select sqrt(@mymath)

Declare @math as numeric (7,2) = 3.7

Select Floor(@math) as myFloor
Select Ceiling(@math) as myCeiling
Select Round(@math, 0) as myRound

select PI() as myPI
select exp(1) as e

Declare @abs as numeric(7,2) = -456
select abs(@abs) as Myabs, sign(@abs) as mysign

select Rand(5678) --Random number

---------------------------------
--Converting between Number Types

--Implicit
Declare @conv as decimal (5,2) = 3

Select @conv

--Explicit
select convert(decimal(5,2),3)/2
select cast(3 as decimal(5,2))/2

------------------------------------
--Practice Activity Number 4
select system_type_id, column_id, round(system_type_id *1.0000 / column_id, 1) as Calculation
from sys.all_columns