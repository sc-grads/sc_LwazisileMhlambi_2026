select FirstName + ' ' + LastName as FullName,
TerritoryName, TerritoryGroup, SalesQuota, SalesYTD, SalesLastYear
into SalesStaff
from sales.vSalesPerson

select * from sales.vSalesPerson

select * from salesstaff

update salesstaff SET SalesQuota = 50000.00
update salesstaff SET SalesQuota = SalesQuota + 150000.00
update salesstaff SET SalesQuota = SalesQuota + 150000.00, 
SalesYTD = SalesYTD - 500, SalesLastYear = SalesLastYear * 1.50

update salesstaff SET TerritoryName = 'UK' where TerritoryName = 'United Kingdom' 

update salesstaff SET TerritoryName = 'UK', TerritoryGroup = 'Europe' where TerritoryGroup  is null and FullName = 'Syed Abbas'

update salesstaff set SalesQuota = sp.salesquota
from salesstaff ss
inner join sales.vSalesPerson sp
on ss.FullName = (sp.firstname + ' ' + sp.lastname)