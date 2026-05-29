select *
from HumanResources.EmployeePayHistory
where BusinessEntityID IN (select BusinessEntityID from HumanResources.EmployeePayHistory where Rate > 60)

select *
from HumanResources.EmployeePayHistory
where BusinessEntityID IN (select BusinessEntityID from HumanResources.EmployeePayHistory where Rate = 60)

select * from Production.Product
where ProductID in (select ProductID from Production.ProductInventory where Quantity >= 300)