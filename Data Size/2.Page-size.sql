USE [DataSize];
GO

SELECT TOP (1000) [FixedSizeTextColumn]
  FROM [dbo].[PageSize_Below4k]
  order by [FixedSizeTextColumn];
GO

SELECT TOP (1000) [FixedSizeTextColumn]
  FROM [dbo].[PageSize_4k]
  order by [FixedSizeTextColumn];
GO

SELECT 
	  record_count
	, page_count
	, avg_page_space_used_in_percent
	, min_record_size_in_bytes
	, max_record_size_in_bytes
	FROM sys.dm_db_index_physical_stats
    (DB_ID(N'DataSize'), OBJECT_ID(N'dbo.PageSize_Below4k'), NULL, NULL , 'DETAILED');

SELECT 
	  record_count
	, page_count
	, avg_page_space_used_in_percent	
	, min_record_size_in_bytes
	, max_record_size_in_bytes
	FROM sys.dm_db_index_physical_stats
    (DB_ID(N'DataSize'), OBJECT_ID(N'dbo.PageSize_4k'), NULL, NULL , 'DETAILED');

GO