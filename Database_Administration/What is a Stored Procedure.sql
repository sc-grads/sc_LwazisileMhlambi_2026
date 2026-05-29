CREATE PROCEDURE SelectAllPersonAddress
as
select *
from person.Address

exec SelectAllPersonAddress

drop procedure SelectAllPersonAddress

CREATE PROCEDURE SelectAllPersonAddressWithParam @City nvarchar(30)
as
select *
from person.Address
where City = @City

exec SelectAllPersonAddressWithParam @City = 'Miami'
exec SelectAllPersonAddressWithParam 'Miami'