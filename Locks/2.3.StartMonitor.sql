 USE [LocksTests];
 
DROP TABLE IF EXISTS #lock_snapshot
DROP TABLE IF EXISTS #wait_snapshot
DROP TABLE IF EXISTS #spids

 CREATE TABLE #lock_snapshot
 (
   event_time           datetime2,
   spid                 smallint,
   resource_type        nvarchar(60),
   request_mode         nvarchar(60),
   resource_description nvarchar(max)
 );
 
 CREATE TABLE #wait_snapshot
 (
   event_time    datetime2,
   spid          smallint, 
   wait_type     nvarchar(60),
   wait_time_ms  bigint,
   [status]      nvarchar(30),
   blocker       smallint,
   wait_resource nvarchar(256)
 );
 
 SELECT cntr_value 
   FROM sys.dm_os_performance_counters 
   WHERE counter_name = N'Lock Memory (KB)';

CREATE TABLE #spids(spid smallint);
 INSERT #spids VALUES(54),(53);
 
 GO
 DECLARE @now datetime2 = sysutcdatetime();
 
 INSERT #lock_snapshot 
 SELECT @now, 
    request_session_id, 
    resource_type, 
    request_mode, 
    resource_description
  FROM sys.dm_tran_locks
  WHERE resource_database_id = DB_ID(N'LocksTests')
  AND request_session_id IN (SELECT spid FROM #spids)
  AND resource_type <> N'DATABASE';
 
 INSERT #wait_snapshot
 SELECT @now, 
    ws.[session_id], 
    ws.wait_type, 
    ws.wait_time_ms,
    r.[status], 
    r.blocking_session_id, 
    r.wait_resource
 FROM sys.dm_exec_session_wait_stats AS ws
 LEFT OUTER JOIN sys.dm_exec_requests AS r
 ON ws.[session_id] = r.[session_id]
 WHERE ws.[session_id] IN (SELECT spid FROM #spids) AND
    ws.wait_time_ms >= 1000
   AND ws.wait_type <> N'WAITFOR';
 
 WAITFOR DELAY '00:00:00.25';
 GO 500

  SELECT spid, 
     rt = CASE resource_type 
          /* XACT = Tid, GRAN = more granular (key/page) */
          WHEN 'XACT' THEN 'XACT' ELSE 'GRAN' END, 
     LockCount = COUNT(*)
 FROM #lock_snapshot
 GROUP BY spid, CASE resource_type 
   WHEN 'XACT' THEN 'XACT' ELSE 'GRAN' END;
 
 SELECT spid, 
     wait_type, 
     WaitTime = MAX(wait_time_ms)
   FROM #wait_snapshot
   GROUP BY spid, wait_type;
 
 SELECT cntr_value 
   FROM sys.dm_os_performance_counters 
   WHERE counter_name = N'Lock Memory (KB)';

DROP TABLE IF EXISTS #lock_snapshot
DROP TABLE IF EXISTS #wait_snapshot
DROP TABLE IF EXISTS #spids