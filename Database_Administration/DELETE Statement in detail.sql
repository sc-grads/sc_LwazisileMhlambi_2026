create table salesstaff (
staffID int not null primary key,
firstname nvarchar(50) not null,
lastname nvarchar(50) not null,
countryregion nvarchar(50) not null
)

drop table salesstaff

select * from salesstaff

insert into salesstaff
select businessentityid, firstname, lastname, countryregionname
from sales.vSalesPerson

delete salesstaff

delete from salesstaff

delete from salesstaff where countryregion = 'united states'

begin tran
delete from salesstaff where countryregion = 'united states'

commit

rollback tran

delete salesstaff
where staffid in (select businessentityid from sales.vSalesPerson where SalesLastYear = 0)

delete salesstaff
from sales.vSalesPerson sp
inner join salesstaff ss
on sp.BusinessEntityID = ss.staffid
where sp.SalesLastYear = 0