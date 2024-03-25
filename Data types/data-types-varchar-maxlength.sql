USE [DataTypes];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[VarcharLength_max]
  order by [TextColumn];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[VarcharLength_1024]
  order by [TextColumn];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[VarcharLength_72]
  order by [TextColumn];
GO

SELECT TOP (1000) [TextColumn]
  FROM [dbo].[VarcharLength_36]
  order by [TextColumn];
GO

SET STATISTICS IO ON

SELECT TOP 10000 [Table1].[TextColumn]
  FROM [dbo].[VarcharLength_max] AS [Table1]
  INNER JOIN [dbo].[VarcharLength_max] AS [Table2]
  ON [Table1].[TextColumn] = [Table2].[TextColumn];
GO

SELECT TOP 10000 [Table1].[TextColumn]
  FROM [dbo].[VarcharLength_1024] AS [Table1]
  INNER JOIN [dbo].[VarcharLength_1024] AS [Table2]
  ON [Table1].[TextColumn] = [Table2].[TextColumn];
GO

SELECT TOP 10000 [Table1].[TextColumn]
  FROM [dbo].[VarcharLength_72] AS [Table1]
  INNER JOIN [dbo].[VarcharLength_72] AS [Table2]
  ON [Table1].[TextColumn] = [Table2].[TextColumn];
GO

SELECT TOP 10000 [Table1].[TextColumn]
  FROM [dbo].[VarcharLength_36] AS [Table1]
  INNER JOIN [dbo].[VarcharLength_36] AS [Table2]
  ON [Table1].[TextColumn] = [Table2].[TextColumn];
GO

SET STATISTICS IO OFF