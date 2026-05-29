-------------------------------------
--Strings

--char - ASCII (1 byte)
--varchar - ASCII (1 byte)
--nchar - UNICODE (2 bytes)
--nvarchar - UNICODE (2 bytes)
A-Z a-z, 0-9
65  97   48  32  128
0-255
ASCII
UNICODE

Declare @mychar as nvarchar(10) --Stored as 12 (5x2+2)
set @mychar = N'hello' --Converts to Nvarchar
select @mychar as myString, len(@mychar) as myLength, DATALENGTH(@mychar) as myDataLength

----------------------------------
--String Functions - Extraction

declare @chrASCII as varchar(10) = 'hellothere'

declare @chrUNICODE as nvarchar (10) = N'hello'

select left(@chrASCII,2) as myASCII, right(@chrUNICODE,2) as myUNICODE
select substring(@chrASCII,3,2) as middleletters

declare @ltrim as varchar(10) = '  hello  '
select ltrim(rtrim(@ltrim)) as Trims
select replace(@ltrim, 'l', 'L') as myReplace
select upper(@ltrim)
select lower(@ltrim)

-----------------------------------------------------
--Null - an introduction
declare @nullnum as int

select @nullnum as myCol

declare @nullstr as nvarchar(20)
select @nullstr as myString

declare @nulldecimal decimal(5,2)
select try_convert(decimal(5,2), 1000) --Using null as an advantage instead of error
select try_cast(1000 as decimal(5,2))

-----------------------------------------------------
--Joining two strings together
declare @fname as nvarchar(20)
declare @mname as nvarchar(20)
declare @lname as nvarchar(20)

set @fname = 'John'
set @mname = 'Walker'
set @lname = 'Smith'

--select @fname + ' ' + @mname + ' ' + @lname as FullName
select @fname + iif(@mname is null, '', ' ' + @mname) + ' ' + @lname as FullName
select @fname + Case when @mname is null then '' else ' ' + @mname end + ' ' + @lname as FullName
select @fname + ' ' + coalesce(' ' + @mname,'') + ' ' + @lname as FullName
select Concat(@fname, ' ' + @mname, ' ', @lname) as FullName

---------------------------------------------------
--Joining a string to a number
select 'My Number is: ' + convert(varchar(20), 4567)
select 'My Number is: ' + cast(4567 as varchar(20))

select 'My salary is: R' + convert(varchar(20), 4567.6)
select 'My salary is: ' + format(4567.6, 'C','fr-FR')

---------------------------------------------------
--Practice Activity Number 5
select [name] + 'A'
from sys.all_columns

select [name] + N'Ⱥ'
from sys.all_columns

select substring([name],2)
from sys.all_columns

select substring([name],1,len([name])-1)
from sys.all_columns

