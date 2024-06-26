SELECT *
INTO #Temp
FROM(
SELECT top 2000
    t.NAME AS TableName,
    i.name as indexName,
    sum(p.rows) as RowCounts,
    sum(a.total_pages) as TotalPages, 
    sum(a.used_pages) as UsedPages, 
    sum(a.data_pages) as DataPages,
    (sum(a.total_pages) * 8) / 1024.0 as TotalSpaceMB, 
    (sum(a.used_pages) * 8) / 1024.0 as UsedSpaceMB, 
    (sum(a.data_pages) * 8) / 1024.0 as DataSpaceMB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    --t.NAME NOT LIKE 'Logs' AND
	--t.Name LIKE 'Customer%' AND
    i.OBJECT_ID > 255    
GROUP BY 
    t.NAME, i.object_id, i.index_id, i.name) tempresult;

select top 100 * from #Temp
ORDER BY TotalPages desc;

DROP TABLE #Temp