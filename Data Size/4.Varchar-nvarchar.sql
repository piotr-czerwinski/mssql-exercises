-- https://techcommunity.microsoft.com/t5/sql-server-blog/introducing-utf-8-support-for-sql-server/ba-p/734928
-- https://learn.microsoft.com/en-us/ef/core/providers/sql-server/columns?tabs=ef-core-7
-- https://www.sqlservercentral.com/forums/topic/nvarchar4000-and-performance#bm1997863

USE [DataSize];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[Varchar_8_Default_Collation]
  order by [TextColumn];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[NVarchar_8_Default_Collation]
  order by [TextColumn];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[Varchar_8_UTF8_ASCII_Content]
  order by [TextColumn];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[Varchar_8_UTF8_PL_CONTENT]
  order by [TextColumn];
GO

SET STATISTICS IO OFF