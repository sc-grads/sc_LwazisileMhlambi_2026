--dm_db_index_usage_stats

--DMV -Dynamic Management View

--Three types that relate to query tuning
--sys.dm_db_mising_index_details
--sys.dm_db_index_usage_stats
--sys.dm_db_index_physical_stats

--Can query the database to see whether or not indexes are being used 

-----------------------------------------------------------
--sys.dm_db_index_physical_stats

select * from
sys.dm_db_index_physical_stats(db_id('Sess7 70-461 T-SQL'), object_id('dbo.tblEmployee')
, Null, Null, 'DETAILED') --Gets the index types for a table

-----------------------------------------------------------
--sys.dm_db_mising_index_details

select * from sys.dm_db_missing_index_details -- sys.dm_db_missing_index_columns
where database_id = db_id()

--This highlights the different types indexes need to be included