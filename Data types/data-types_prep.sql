USE master;
GO

IF  EXISTS (SELECT [Name] FROM sys.databases WHERE name = N'DataTypes')
BEGIN
	ALTER DATABASE [DataTypes] set single_user with rollback immediate
	DROP DATABASE [DataTypes];
END
GO

CREATE DATABASE [DataTypes] ON
(
	NAME = DataTypes_dat,
	FILENAME = '/var/opt/mssql/data/datatypes.mdf',
    SIZE = 512 MB,
    FILEGROWTH = 64 MB)
LOG ON
(
	NAME = DataTypes_log, 
	FILENAME = '/var/opt/mssql/data/datatypes.ldf',
    SIZE = 512 MB,
    FILEGROWTH = 64 MB);
GO

USE [DataTypes];
GO

CREATE TABLE [dbo].[SmallintRangeSource] (
    [VALUE] smallint NOT NULL
);
GO

CREATE TABLE [dbo].[VarcharSize_Max] (
    [textColumn] VARCHAR (MAX) NOT NULL
);
GO

CREATE TABLE [dbo].[VarcharSize_1024] (
    [textColumn] VARCHAR (1024) NOT NULL
);
GO

CREATE TABLE [dbo].[VarcharSize_36] (
    [textColumn] VARCHAR (36) NOT NULL
);
GO

WITH [NUMRANGE] AS (
  SELECT 1 AS N
  UNION ALL
  SELECT N + 1 as N
  from [NUMRANGE]
  where N < 32767
 )
 INSERT INTO [dbo].[SmallintRangeSource]
SELECT N 
	FROM [NUMRANGE]
	option (maxrecursion 0);
GO

DECLARE @VarCharTestRowCount int;
SET @VarCharTestRowCount = 5000000; --5kk

INSERT INTO [dbo].[VarcharSize_Max]
SELECT TOP (@VarCharTestRowCount) NEWID() 
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[VarcharSize_1024]
SELECT TOP (@VarCharTestRowCount) NEWID() 
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[VarcharSize_36]
SELECT TOP (@VarCharTestRowCount) NEWID() 
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;
GO