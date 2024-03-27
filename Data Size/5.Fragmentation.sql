USE [DataSize];
GO

SELECT 
	  record_count
	, page_count
	, avg_page_space_used_in_percent
	, min_record_size_in_bytes
	, max_record_size_in_bytes
	, avg_fragmentation_in_percent
	FROM sys.dm_db_index_physical_stats
    (DB_ID(N'DataSize'), OBJECT_ID(N'dbo.Fragmented'), NULL, NULL , 'DETAILED');

SELECT 
	  record_count
	, page_count
	, avg_page_space_used_in_percent	
	, min_record_size_in_bytes
	, max_record_size_in_bytes
	, avg_fragmentation_in_percent
	FROM sys.dm_db_index_physical_stats
    (DB_ID(N'DataSize'), OBJECT_ID(N'dbo.Defragmented'), NULL, NULL , 'DETAILED');

GO