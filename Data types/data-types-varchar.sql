USE [DataTypes];
GO

SELECT TOP (1) [textColumn]
  FROM [dbo].[VarcharSize_max]
  order by [textColumn];
GO

SELECT TOP (1) [textColumn]
  FROM [dbo].[VarcharSize_1024]
  order by [textColumn];
GO

SELECT TOP (1) [textColumn]
  FROM [dbo].[VarcharSize_36]
  order by [textColumn];
GO

SET STATISTICS IO ON

SELECT TOP 10000 [Table1].[textColumn]
  FROM [dbo].[VarcharSize_max] AS [Table1]
  INNER JOIN [dbo].[VarcharSize_max] AS [Table2]
  ON [Table1].[textColumn] = [Table2].[textColumn];
GO

SELECT TOP 10000 [Table1].[textColumn]
  FROM [dbo].[VarcharSize_1024] AS [Table1]
  INNER JOIN [dbo].[VarcharSize_1024] AS [Table2]
  ON [Table1].[textColumn] = [Table2].[textColumn];
GO

SELECT TOP 10000 [Table1].[textColumn]
  FROM [dbo].[VarcharSize_36] AS [Table1]
  INNER JOIN [dbo].[VarcharSize_36] AS [Table2]
  ON [Table1].[textColumn] = [Table2].[textColumn];
GO

SET STATISTICS IO OFF