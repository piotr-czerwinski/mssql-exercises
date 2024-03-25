USE [DataTypes];
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