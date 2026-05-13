CREATE TABLE [AdventureWorks2022].[sales].[visits] (
vist_id INT PRIMARY KEY IDENTITY (1,1),
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
visted_at DATETIME,
phone VARCHAR(20),
store_id INT NOT NULL,
FOREIGN KEY (store_id) REFERENCES sales.storenew (store_id)
)


CREATE TABLE [AdventureWorks2022].[sales].[storenew] (

store_id INT NOT NULL,
sales INT
)

use AdventureWorks2022
select BusinessEntityID, firstname, lastname, Title
into #TempPersonaTable
from [Person].[Person]
where title = 'mr.'


use AdventureWorks2022
select BusinessEntityID, firstname, lastname, Title

from [Person].[Person]
where title = 'mr.'

Select * 
From #TempPersonaTable

Drop Table #TempPersonaTable