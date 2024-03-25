﻿USE master;
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

WITH [NumRange] AS (
  SELECT 1 AS N
  UNION ALL
  SELECT N + 1 as N
  from [NumRange]
  where N < 32767
 )
 INSERT INTO [dbo].[SmallintRangeSource]
SELECT N 
	FROM [NumRange]
	option (maxrecursion 0);
GO

-- data-types-varchar-maxlength
CREATE TABLE [dbo].[VarcharLength_Max] (
    [TextColumn] VARCHAR (MAX) NOT NULL
);
GO

CREATE TABLE [dbo].[VarcharLength_1024] (
    [TextColumn] VARCHAR (1024) NOT NULL
);
GO

CREATE TABLE [dbo].[VarcharLength_72] (
    [TextColumn] VARCHAR (72) NOT NULL
);
GO

CREATE TABLE [dbo].[VarcharLength_36] (
    [TextColumn] VARCHAR (36) NOT NULL
);
GO

DECLARE @VarCharTestRowCount int;
SET @VarCharTestRowCount = 1024 * 1024; --~1kk

INSERT INTO [dbo].[VarcharLength_Max]
SELECT TOP (@VarCharTestRowCount) NEWID() -- guid length 36
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[VarcharLength_1024]
SELECT TOP (@VarCharTestRowCount) NEWID() 
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[VarcharLength_72]
SELECT TOP (@VarCharTestRowCount) NEWID() 
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[VarcharLength_36]
SELECT TOP (@VarCharTestRowCount) NEWID() 
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;
GO



-- data-types-varchar-nvarchar
SELECT CONVERT (varchar(256), SERVERPROPERTY('collation'));  

CREATE TABLE [dbo].[Varchar_8_Default_Collation] (
    [TextColumn] VARCHAR (8) NOT NULL
);
GO

CREATE TABLE [dbo].[NVarchar_8_Default_Collation] (
    [TextColumn] NVARCHAR (8) NOT NULL
);
GO

/*
Starting with sql 2019
modelBuilder.Entity<Varchar_UTF8_ASCII_Conten>()
        .Property(b => b.TextColumn)
        .HasColumnType("varchar(8)")
        .UseCollation("LATIN1_GENERAL_100_CI_AS_SC_UTF8")
        .IsUnicode();
*/
CREATE TABLE [dbo].[Varchar_8_UTF8_ASCII_Content] (
    [TextColumn] VARCHAR (8) COLLATE Latin1_General_100_CI_AI_SC_UTF8 NOT NULL 
);
GO

CREATE TABLE [dbo].[Varchar_8_UTF8_PL_CONTENT] (
    [TextColumn] VARCHAR (8) COLLATE Latin1_General_100_CI_AI_SC_UTF8 NOT NULL
);
GO

TRUNCATE TABLE [dbo].[Varchar_8_Default_Collation];
TRUNCATE TABLE [dbo].[NVarchar_8_Default_Collation];
TRUNCATE TABLE [dbo].[Varchar_8_UTF8_ASCII_Content];
TRUNCATE TABLE [dbo].[Varchar_8_UTF8_PL_CONTENT];

DECLARE @UTF8TestRowCount int;
SET @UTF8TestRowCount = 1024 * 1024; --~1kk

INSERT INTO [dbo].[Varchar_8_Default_Collation]
SELECT TOP (@UTF8TestRowCount) '12345678'
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[NVarchar_8_Default_Collation]
SELECT TOP (@UTF8TestRowCount) '12345678'
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[Varchar_8_UTF8_ASCII_Content]
SELECT TOP (@UTF8TestRowCount) '12345678'
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

INSERT INTO [dbo].[Varchar_8_UTF8_PL_CONTENT]
SELECT TOP (@UTF8TestRowCount) N'ąęłó' -- in utf8 pl characters are 2 bytes long. This means only 4 chars would fit in varchar8
FROM [SmallintRangeSource] AS SRS1
CROSS JOIN [SmallintRangeSource] AS SRS2;

GO