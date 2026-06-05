--Creating Our First Procedure

create proc NameEmployees as
begin
	select EmployeeNumber, EmployeeFirstName, EmployeeLastName
	from tblEmployee
end
go

exec NameEmployees

-----------------------------------------------------------
--Ask for a specific employee

--if exists (select * from sys.procedures where name = 'NameEmployees')
if object_id('NameEmployees', 'P') is not null
drop proc NameEmployees
go

create proc NameEmployees(@EmployeeNumber int) as
begin
	if exists (Select * from tblEmployee where EmployeeNumber = @EmployeeNumber)
	select EmployeeNumber, EmployeeFirstName, EmployeeLastName
	from tblEmployee
	where EmployeeNumber = @EmployeeNumber
end
go

NameEmployees 123
execute NameEmployees 223
exec NameEmployees 223

Declare @EmployeeName int = 123

-----------------------------------------------------------
--Exercise with IF

if object_id('NameEmployees', 'P') is not null
drop proc NameEmployees
go

create proc NameEmployees(@EmployeeNumber int) as
begin
	if exists (Select * from tblEmployee where EmployeeNumber = @EmployeeNumber)
	begin
		if @EmployeeNumber < 300
		begin
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName
			from tblEmployee
			where EmployeeNumber = @EmployeeNumber
		end
		else
		begin 
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName, Department
			from tblEmployee
			where EmployeeNumber = @EmployeeNumber
			select * from tblEmployee where EmployeeNumber = @EmployeeNumber
		end
	end

end
go

NameEmployees 4
execute NameEmployees 223
exec NameEmployees 323

-----------------------------------------------------------
-- Multiple Arguments

if object_id('NameEmployees', 'P') is not null
drop proc NameEmployees
go

create proc NameEmployees(@EmployeeNumberFrom int, @EmployeeNumberTo int) as
begin
	if exists (Select * from tblEmployee where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo)
	begin
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName
			from tblEmployee
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo
	end

end
go

NameEmployees 4, 5
execute NameEmployees 223, 227
exec NameEmployees 323, 327
go

-----------------------------------------------------------
-- While

if object_id('NameEmployees', 'P') is not null
drop proc NameEmployees
go

create proc NameEmployees(@EmployeeNumberFrom int, @EmployeeNumberTo int) as
begin
	if exists (Select * from tblEmployee where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo)
	begin
		declare @EmployeeNumber int = @EmployeeNumberFrom
		while @EmployeeNumber <= @EmployeeNumberTo
		begin
			if not exists (select * from tblEmployee where EmployeeNumber = @EmployeeLastName
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName
			from tblEmployee
			where EmployeeNumber = @EmployeeNumber
			Set @EmployeeNumber = @EmployeeNumber + 1
		end
	end
end
go

NameEmployees 4, 5
execute NameEmployees 223, 227
exec NameEmployees 323, 327

-----------------------------------------------------------
--Return 

if object_id('NameEmployees', 'P') is not null
drop proc NameEmployees
go

create proc NameEmployees(@EmployeeNumberFrom int, @EmployeeNumberTo int, @NumberOfRows int OUTPUT) as
begin
	if exists (Select * from tblEmployee where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo)
	begin
			select EmployeeNumber, EmployeeFirstName, EmployeeLastName
			from tblEmployee
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo
			Set @NumberOfRows = @@ROWCOUNT
			RETURN 0
	end
end
go

NameEmployees 4, 5, @NumberRows Output
Declare @NumberRows int
execute NameEmployees 223, 227, @NumberRows Output
select @NumberRows as MyRowCount
exec NameEmployees 323, 327