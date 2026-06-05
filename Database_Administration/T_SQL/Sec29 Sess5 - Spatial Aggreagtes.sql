--POINT

Begin Tran
Create Table tblGeom
(GXY geometry,
Description varchar(30),
IDtblGeom int Constraint PK_tblGeom Primary Key Identity (1,1))
Insert Into tblgeom
Values (geometry::STGeomFromText('POINT (3 4)', 0), 'First Point'),
	   (geometry::STGeomFromText('POINT (3 5)', 0), 'Second Point'),
	   (geometry::Point(4, 6, 0), 'Third Point'),
	   (geometry::STGeomFromText('MULTIPOINT ((1 2), (2 3), (3 4))', 0), 'Three Points')

select * from tblGeom
rollback tran
go

-----------------------------------------------------------
--POINT queries


Begin Tran
Create Table tblGeom
(GXY geometry,
Description varchar(30),
IDtblGeom int Constraint PK_tblGeom Primary Key Identity (1,1))
Insert Into tblgeom
Values (geometry::STGeomFromText('POINT (3 4)', 0), 'First Point'),
	   (geometry::STGeomFromText('POINT (3 5)', 0), 'Second Point'),
	   (geometry::Point(4, 6, 0), 'Third Point'),
	   (geometry::STGeomFromText('MULTIPOINT ((1 2), (2 3), (3 4))', 0), 'Three Points')

select * from tblGeom

select IDtblGeom, GXY.STGeometryType() as MyType
, GXY.STStartPoint().ToString() as StartingPoint
, GXY.STStartPoint().ToString() as Ending
, GXY.STPointN(1).ToString() as FirstPoint
, GXY.STPointN(2).ToString() as SecondPoint
, GXY.STPointN(1).STX as FirstPointX
, GXY.STPointN(1).STY as FirstPointY
, GXY.STNumPoints() as NumberPoints
from tblGeom


declare @g as geometry
declare @h as geometry

select @g = GXY from tblGeom where IDtblGeom = 1
select @h = GXY from tblGeom where IDtblGeom = 3
select @g.STDistance(@h) as myDistance

select @g, 'Point 1'
union all
select @h, 'Point 2'

rollback tran

-----------------------------------------------------------
--Line, POLYGON, and Circles

begin tran
create table tblGeom
(GXY geometry,
Description varchar(20),
IDtblGeom int Constraint PK_tblGeom Primary Key Identity(5,1))
insert into tblGeom
Values (geometry::STGeomFromText('LINESTRING (1 1, 5 5)', 0), 'First line'),
	   (geometry::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0), 'Second line'),
	   (geometry::STGeomFromText('MULTILINESTRING ((1 5, 2 6), (1 4, 2 1))', 0), 'Third line'),
	   (geometry::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (geometry::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Polygon')

Select * From tblGeom 
rollback tran
go

-----------------------------------------------------------
--Line Queries

Begin Tran
Create Table tblGeom
(GXY geometry,
Description varchar(30),
IDtblGeom int Constraint PK_tblGeom Primary Key Identity (1,1))
Insert Into tblgeom
Values (geometry::STGeomFromText('LINESTRING (1 1, 5 5)', 0), 'First line'),
	   (geometry::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0), 'Second line'),
	   (geometry::STGeomFromText('MULTILINESTRING ((1 5, 2 6), (1 4, 2 1))', 0), 'Third line'),
	   (geometry::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (geometry::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Polygon')

select * from tblGeom

select IDtblGeom, GXY.STGeometryType() as MyType
, GXY.STStartPoint().ToString() as StartingPoint
, GXY.STStartPoint().ToString() as Ending
, GXY.STPointN(1).ToString() as FirstPoint
, GXY.STPointN(2).ToString() as SecondPoint
, GXY.STPointN(1).STX as FirstPointX
, GXY.STPointN(1).STY as FirstPointY
, GXY.STNumPoints() as NumberPoints
from tblGeom


declare @g as geometry
select @g = GXY from tblGeom where IDtblGeom = 5

select IDtblGeom, GXY.STIntersection(@g).ToString() as Intersection
, GXY.STDistance(@g) as DistanceFromFirstLine
from tblGeom

select GXY.STUnion(@g), Description
from tblGeom
where IDtblGeom = 8

rollback tran
go
-----------------------------------------------------------
--Geography

Begin Tran
Create Table tblGeog
(GXY geography,
Description varchar(30),
IDtblGeog int Constraint PK_tblGeog Primary Key Identity (1,1))
Insert Into tblgeog
Values (geography::STGeomFromText('POINT (-73.993492 40.750525)', 4326), 'Madison Square Gardens, NY'),
	   (geography::STGeomFromText('POINT (-0.177452 51.500905)', 4326), 'Royal Albert Hall, London'),
	   (geography::STGeomFromText('LINESTRING (-73.993492 40.750525, -0.177452 51.500905)', 4326), 'Connection')

select * from tblGeog

DECLARE @g as geography
select @g = GXY from tblGeog where IDtblGeog = 1

select IDtblGeog, GXY.STGeometryType() as MyType
, GXY.STStartPoint().ToString() as StartingPoint
, GXY.STStartPoint().ToString() as Ending
, GXY.STPointN(1).ToString() as FirstPoint
, GXY.STPointN(2).ToString() as SecondPoint
, GXY.STLength() as MyLength
, GXY.STIntersection(@g).ToString() as Intersection
, GXY.STNumPoints() as NumberPoints
, GXY.STDistance(@g) as DistanceFromFirstLine
from tblGeog

Declare @h as geography

select @g = GXY from tblGeog where IDtblGeog = 1
select @g = GXY from tblGeog where IDtblGeog = 2
select @g.STDistance(@h) as MyDistance

select GXY.STUnion(@g)
from tblGeog
where IDtblGeog =2 

rollback tran

-----------------------------------------------------------
--Spatial Aggregates

begin tran
create table tblGeom
(GXY geometry,
Description varchar(20),
IDtblGeom int Constraint PK_tblGeom Primary Key Identity(5,1))
insert into tblGeom
Values (geometry::STGeomFromText('LINESTRING (1 1, 5 5)', 0), 'First line'),
	   (geometry::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0), 'Second line'),
	   (geometry::STGeomFromText('MULTILINESTRING ((1 5, 2 6), (1 4, 2 1))', 0), 'Third line'),
	   (geometry::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (geometry::STGeomFromText('POLYGON ((5 2, 7 2, 7 4, 5 4, 5 2))', 0), 'Second Polygon'),
	   (geometry::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Cirlce')

Select *, GXY.Filter(geometry::Parse('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))')) From tblGeom 
union all
select geometry::STGeomFromText('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))', 0), 'Filter', 0, 0 

rollback tran
go

--UnionAggregate
--CollectionAggregate
--EnvelopeAggregate
--ConvexHullAggregate