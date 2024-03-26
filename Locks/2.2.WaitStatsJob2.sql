 USE [LocksTests];
 
 WAITFOR TIME '17:30';
 BEGIN TRANSACTION;
 
 DECLARE @i int = 1, @batch_size int = 500;
 
 WHILE @i <= 1000 
 BEGIN 
   WITH x AS 
   (
     SELECT * FROM dbo.[DummyTable] 
       WHERE Id >  (@batch_size*(@i-1))
         AND Id <= (@batch_size*(@i))
   )
   UPDATE x SET Status = @@SPID;
 
   SET @i += 1;
 END
 
 COMMIT TRANSACTION;