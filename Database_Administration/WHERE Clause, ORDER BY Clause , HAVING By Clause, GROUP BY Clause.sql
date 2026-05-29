Select * From Person.Address Where PostalCode = '98011'

Select * From Person.Address Where PostalCode != '98011'

Select * From Person.Address Where PostalCode <> '98011'

Select count(*) From Person.Address Where PostalCode <> '98011'

Select * From Person.Address Where ModifiedDate <= '2013-11-08 00:00:00.000'

Select * From Person.Person Where FirstName LIKE 'MAT%'

Select MAX(Rate) As PayRate From HumanResources.EmployeePayHistory

Select MIN(Rate) As MinPayRate From HumanResources.EmployeePayHistory

Select * From Production.ProductCostHistory Where StartDate = '2013-05-30 00:00:00.000'

Select * From Production.ProductCostHistory Where StartDate = '2013-05-30 00:00:00.000' AND StandardCost >= 200.00

Select * From Production.ProductCostHistory Where (StartDate = '2013-05-30 00:00:00.000' AND StandardCost >= 200.00) OR ProductID > 800

Select * From Production.ProductCostHistory Where ProductID IN (802, 803, 820,900)

Select * From Production.ProductCostHistory Where EndDate is Null

Select * From Production.ProductCostHistory Where EndDate is not null

--------------------------------------------------------------------------

Select * From HumanResources.EmployeePayHistory order by rate

Select * From HumanResources.EmployeePayHistory order by rate ASC

Select * From HumanResources.EmployeePayHistory order by rate DESC

Select * From HumanResources.EmployeePayHistory where ModifiedDate >= '2010-06-30 00:00:00.000' Order by ModifiedDate DESC

Select * From HumanResources.EmployeePayHistory where Year(ModifiedDate) >= '2014' order by  ModifiedDate Desc

--------------------------------------------------------------------------

Select count(*) from Person.Address Where PostalCode = '98011'

Select * from Person.Address Where PostalCode = '98011'

Select count(*) from Person.Address Where PostalCode = '98225'

Select count(*), PostalCode from Person.Address group by PostalCode order by PostalCode Desc

Select count(*), City from Person.Address group by City order by City desc

--------------------------------------------------------------------------

Select count(1) as CountOfProduct, Color From Production.Product where Color = 'yellow' group by Color

Select count(1) as CountOfProduct, Color From Production.Product group by Color Having Color = 'yellow'

Select count(1) as CountOfProduct, Color, Size From Production.Product group by Color, Size Having Size >= '44'