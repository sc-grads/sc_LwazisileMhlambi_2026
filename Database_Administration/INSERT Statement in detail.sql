create table salesstaff (
staffid int not null primary key,
fName nvarchar(30) not null,
lName nvarchar(30) not null)

insert into salesstaff (staffid, fName, lName)
values (200, 'lwazisile', 'mhlambi')

select * from salesstaff

insert into salesstaff (staffid, fName, lName)
values (210, 'abbas', 'mehmood'),
(300, 'Imran', 'Afzal'),
(325, 'john', 'wick'),
(314, 'james', 'dino')

create table salesstaffNew (
ID int not null Identity primary key, --Identity auto increments
staffid int not null,
fName nvarchar(30),
lName nvarchar(30) )

insert into salesstaffNew (staffid, fName, lName)
values (200, 'lwazisile', 'mhlambi')

select * from salesstaffNew

insert into salesstaffNew (staffid, fName, lName)
values (210, 'abbas', 'mehmood'),
(300, 'Imran', 'Afzal'),
(325, 'john', 'wick'),
(314, 'james', 'dino')

create table nameOnlyTable (

fName nvarchar(30),
lName nvarchar(30) )

select * from nameOnlyTable

insert nameOnlyTable (fName, lName)
select fName, lName from salesstaffNew where id >= 3

select * into salesstaffNew_bkp from salesstaffNew

select * from salesstaffNew_bkp 