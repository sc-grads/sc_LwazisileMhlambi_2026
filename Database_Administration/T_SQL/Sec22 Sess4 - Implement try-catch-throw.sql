--Procedure Exercise

select * from tblTransaction
where EmployeeNumber between 3 and 11

select sum(Amount) from tblTransaction
where EmployeeNumber between 3 and 11

select count(distinct EmployeeNumber) from tblTransaction
where EmployeeNumber between 3 and 11

select count(distinct EmployeeNumber) from tblEmployee
where EmployeeNumber between 3 and 11

if object_id('AverageBalance', 'P') is not null
drop proc AverageBalance
go

create proc AverageBalance(@EmployeeNumberFrom int, @EmployeeNumberTo int, @AverageBalance int OUTPUT) as
begin
	begin
			declare @TotalAmount money
			declare @NumOfEmployee int
			select @TotalAmount = sum(Amount) from tblTransaction
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			select @NumOfEmployee =count(distinct EmployeeNumber) from tblEmployee
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			SET @AverageBalance = @TotalAmount/@NumOfEmployee


	end
end
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 223, 227, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status

-----------------------------------------------------------
-- TRY/Catch

--Spots errors and prevents them from happening

if object_id('AverageBalance', 'P') is not null
drop proc AverageBalance
go

create proc AverageBalance(@EmployeeNumberFrom int, @EmployeeNumberTo int, @AverageBalance int OUTPUT) as
begin
	begin
			declare @TotalAmount money
			declare @NumOfEmployee int
			begin try
			select @TotalAmount = sum(Amount) from tblTransaction
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			select @NumOfEmployee =count(distinct EmployeeNumber) from tblEmployee
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			SET @AverageBalance = @TotalAmount/@NumOfEmployee
			Return 0
			end try
			begin catch
			set @AverageBalance = 0
			Select ERROR_MESSAGE() as ErrorMessage, ERROR_LINE() as ErrorLine,
				   ERROR_NUMBER() as ErrorNumber, ERROR_PROCEDURE() as ErrorProcedure,
				   ERROR_SEVERITY() as ErrorServerity, ERROR_STATE() as ErrorState
			Return 1
			end catch

	end
end
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 223, 227, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 4, 5, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status
go

-----------------------------------------------------------
--THROW and RaiseError

if object_id('AverageBalance', 'P') is not null
drop proc AverageBalance
go

create proc AverageBalance(@EmployeeNumberFrom int, @EmployeeNumberTo int, @AverageBalance int OUTPUT) as
begin
	begin
			declare @TotalAmount money
			declare @NumOfEmployee int
			begin try
			select @TotalAmount = sum(Amount) from tblTransaction
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			select @NumOfEmployee =count(distinct EmployeeNumber) from tblEmployee
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			SET @AverageBalance = @TotalAmount/@NumOfEmployee
			Return 0
			end try
			begin catch
			set @AverageBalance = 0
			if ERROR_NUMBER() = 8134
			begin

				set @AverageBalance = 0
				Return 8134

			end
			else
				raiserror ('Unknown Err', 10, 1)
				throw 56789, 'Unknown Error', 1

			--Select ERROR_MESSAGE() as ErrorMessage, ERROR_LINE() as ErrorLine,
				--   ERROR_NUMBER() as ErrorNumber, ERROR_PROCEDURE() as ErrorProcedure,
				  -- ERROR_SEVERITY() as ErrorServerity, ERROR_STATE() as ErrorState
			Return 1
			end catch

	end
end
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 223, 227, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 4, 5, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status
go

-----------------------------------------------------------
--Print

if object_id('AverageBalance', 'P') is not null
drop proc AverageBalance
go

create proc AverageBalance(@EmployeeNumberFrom int, @EmployeeNumberTo int, @AverageBalance int OUTPUT) as
begin
	begin
			declare @TotalAmount money
			declare @NumOfEmployee int
			begin try
			print 'The employee numbers are from ' + convert(varchar(10), @EmployeeNumberFrom)
			+ ' to ' + convert(varchar(10), @EmployeeNumberTo)
			select @TotalAmount = sum(Amount) from tblTransaction
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			select @NumOfEmployee =count(distinct EmployeeNumber) from tblEmployee
			where EmployeeNumber between @EmployeeNumberFrom and @EmployeeNumberTo

			SET @AverageBalance = @TotalAmount/@NumOfEmployee
			Return 0
			end try
			begin catch
			set @AverageBalance = 0
			if ERROR_NUMBER() = 8134
			begin

				set @AverageBalance = 0
				Return 8134

			end
			else
				--raiserror ('Unknown Error', 10, 1)
				throw 56789, 'Unknown Error', 1

			--Select ERROR_MESSAGE() as ErrorMessage, ERROR_LINE() as ErrorLine,
				--   ERROR_NUMBER() as ErrorNumber, ERROR_PROCEDURE() as ErrorProcedure,
				  -- ERROR_SEVERITY() as ErrorServerity, ERROR_STATE() as ErrorState
			Return 1
			end catch

	end
end
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 223, 227, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status
go

Declare @AvgBalance int, @Returnstatus int
execute @Returnstatus = AverageBalance 4, 5, @AvgBalance Output
select @AvgBalance as Average_Balance, @Returnstatus as Return_Status
go