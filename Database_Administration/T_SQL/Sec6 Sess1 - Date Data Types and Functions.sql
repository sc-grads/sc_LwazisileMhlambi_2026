----------------------------------------------------------
--Setting Dates and Date Extraction

declare @mydate as datetime = '2015-06-24 12:34:56.124'
select @mydate as MyDate

declare @mydate2 as datetime2 = '20150624 12:34:56.124'
select @mydate2 as MyDate

select datefromparts(2015,06,24) as ThisDate
select datetime2fromparts(2015,06,24,12,34,56,124,3) as ThatDate
select year(@mydate) as myYear, month(@mydate) as myMonth, day(@mydate) as myDay, hour(@mydate) as myHour

----------------------------------------------------------
--Today's date and more functions
Select CURRENT_TIMESTAMP as Rightnow
select getdate() as Rightnow
select sysdatetime() as Rightnow
select dateadd(Year, 1, '2015-01-02 03:04:05') as myYear
select datepart(hour, '2015-01-02 03:04:05') as myHour
select datename(WEEKDAY, getdate()) as myAnswer
select datediff(Second, '2015-01-02 03:04:05', getdate()) as SecondElapsed

----------------------------------------------------------
--Date Offset

declare @dateoffset as datetimeoffset = '2015-06-25 01:02:03.456 +5:30'
select @dateoffset as myDateOffset

declare @date as datetime2 = '2015-06-25 01:02:03.456'
select TODATETIMEOFFSET(@date, '+05:30') as DateOffset --adds timezone

select DATETIME2FROMPARTS(2015,06,25,1,2,3,456,3)
select DATETIMEOFFSETFROMPARTS(2015,06,25,1,2,3,456,5,30,3) as DateOffset

select SYSDATETIMEOFFSET() as TimeNowWithOffset;
select SYSUTCDATETIME() as TimeNowUTC; --GMT Time

declare @dateoffset2 as datetimeoffset = '2015-06-25 01:02:03.456 +5:30'
select SWITCHOFFSET(@dateoffset2, '-05:00') as Newdate

-----------------------------------------------------------
--Converting From Date to Strings

declare @datestr as datetime = '2015-06-25 01:02:03.456'
select 'The date and time is: ' + @datestr
go

declare @datestr as datetime = '2015-06-25 01:02:03.456'
select 'The date and time is: ' +convert(nvarchar(20), @datestr) as ConvertedDate
go

declare @datestr as datetime = '2015-06-25 01:02:03.456'
select cast(@datestr as nvarchar(20)) as CastDate
go

select convert(date,'Thursday, 25 June 2015') as ConvertedDate
select parse('Thursday, 25 June 2015' as date using 'es-ES') as ParsedDate

select format(cast('2015-06-25 01:02:03.456' as datetime), 'D') as Longdate
select format(cast('2015-06-25 01:02:03.456' as datetime), 'd') as Shortdate
select format(cast('2015-06-25 01:02:03.456' as datetime), 'dd-MM-yyyy') as BritishDate
select format(cast('2015-06-25 01:02:03.456' as datetime), 'D', 'es-ES') as Longdate





