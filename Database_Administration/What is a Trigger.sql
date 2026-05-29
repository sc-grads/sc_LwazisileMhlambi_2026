Create Trigger EmployeeInsert
On Employee
After Insert
as
begin

set nocount on;

Insert into EmployeeTriggerHistory values ((select top(1) EmpID from Employee), 'Insert')

End
Go

select * from EmployeeTriggerHistory