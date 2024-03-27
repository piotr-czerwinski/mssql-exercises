USE master;

BEGIN  -- DB INIT

IF  EXISTS (SELECT [Name] FROM sys.databases WHERE name = N'DataSize')
BEGIN
	ALTER DATABASE [DataSize] set single_user with rollback immediate
	DROP DATABASE [DataSize];
END

CREATE DATABASE [DataSize] ON
(
	NAME = DataSize_dat,
	FILENAME = '/var/opt/mssql/data/DataSize.mdf',
    SIZE = 512 MB,
    FILEGROWTH = 64 MB)
LOG ON
(
	NAME = DataSize_log, 
	FILENAME = '/var/opt/mssql/data/DataSize.ldf',
    SIZE = 512 MB,
    FILEGROWTH = 64 MB);
END
GO

USE [DataSize];

BEGIN -- page-size
CREATE TABLE [dbo].[PageSize_Below4k] (
	  [FixedSizeTextColumn] CHAR (4039) NULL
);

CREATE TABLE [dbo].[PageSize_4k] (
	  [FixedSizeTextColumn] CHAR (4040) NULL
);

INSERT INTO [dbo].[PageSize_Below4k] ([FixedSizeTextColumn])
SELECT 'a'
FROM GENERATE_SERIES(1, 16 * 1024);

INSERT INTO [dbo].[PageSize_4k] ([FixedSizeTextColumn])
SELECT 'a'
FROM GENERATE_SERIES(1, 16 * 1024);

END

BEGIN -- varchar-maxlength

CREATE TABLE [dbo].[VarcharLength_Max] (
    [TextColumn] VARCHAR (MAX) NOT NULL
);

CREATE TABLE [dbo].[VarcharLength_1024] (
    [TextColumn] VARCHAR (1024) NOT NULL
);

CREATE TABLE [dbo].[VarcharLength_72] (
    [TextColumn] VARCHAR (72) NOT NULL
);

CREATE TABLE [dbo].[VarcharLength_36] (
    [TextColumn] VARCHAR (36) NOT NULL
);

DECLARE @VarCharTestRowCount int;
SET @VarCharTestRowCount = 1024 * 1024; --~1kk

INSERT INTO [dbo].[VarcharLength_Max]
SELECT NEWID() -- guid length 36
FROM GENERATE_SERIES(1, @VarCharTestRowCount);

INSERT INTO [dbo].[VarcharLength_1024]
SELECT NEWID() 
FROM GENERATE_SERIES(1, @VarCharTestRowCount);

INSERT INTO [dbo].[VarcharLength_72]
SELECT NEWID() 
FROM GENERATE_SERIES(1, @VarCharTestRowCount);

INSERT INTO [dbo].[VarcharLength_36]
SELECT NEWID() 
FROM GENERATE_SERIES(1, @VarCharTestRowCount);

END


BEGIN -- varchar-nvarchar
SELECT CONVERT (varchar(256), SERVERPROPERTY('collation'));  

CREATE TABLE [dbo].[Varchar_8_Default_Collation] (
    [TextColumn] VARCHAR (8) NOT NULL
);

CREATE TABLE [dbo].[NVarchar_8_Default_Collation] (
    [TextColumn] NVARCHAR (8) NOT NULL
);

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

CREATE TABLE [dbo].[Varchar_8_UTF8_PL_CONTENT] (
    [TextColumn] VARCHAR (8) COLLATE Latin1_General_100_CI_AI_SC_UTF8 NOT NULL
);

DECLARE @UTF8TestRowCount int;
SET @UTF8TestRowCount = 1024 * 1024; --~1kk

INSERT INTO [dbo].[Varchar_8_Default_Collation]
SELECT '12345678'
FROM GENERATE_SERIES(1, @UTF8TestRowCount);

INSERT INTO [dbo].[NVarchar_8_Default_Collation]
SELECT '12345678'
FROM GENERATE_SERIES(1, @UTF8TestRowCount);

INSERT INTO [dbo].[Varchar_8_UTF8_ASCII_Content]
SELECT '12345678'
FROM GENERATE_SERIES(1, @UTF8TestRowCount);

INSERT INTO [dbo].[Varchar_8_UTF8_PL_CONTENT]
SELECT N'ąęłó' -- in utf8 pl characters are 2 bytes long. This means only 4 chars would fit in varchar8
FROM GENERATE_SERIES(1, @UTF8TestRowCount);

END

BEGIN  -- Fragmentation

DECLARE @DefragmentationTestRowCount int;
 SET @DefragmentationTestRowCount = 128 * 1024;

CREATE TABLE [dbo].[Defragmented]
 (
   Id int NOT NULL,
   Status tinyint NOT NULL DEFAULT 0,
   VariableSizeText varchar(100)  NOT NULL DEFAULT '',
   CONSTRAINT PK_Defragmented PRIMARY KEY(Id)
 );

 CREATE TABLE [dbo].[Fragmented]
 (
   Id int NOT NULL,
   Status tinyint NOT NULL DEFAULT 0,
   VariableSizeText varchar(100)  NOT NULL DEFAULT '',
   CONSTRAINT PK_Fragmented PRIMARY KEY(Id)
 );

INSERT [dbo].[Defragmented](Id, VariableSizeText)
   SELECT value, REPLICATE('a', (abs(CHECKSUM(newid())) % 100))
     FROM GENERATE_SERIES(1, @DefragmentationTestRowCount);

ALTER INDEX ALL ON [dbo].[Defragmented] REBUILD;
 
INSERT [dbo].[Fragmented](Id, VariableSizeText)
   SELECT value, REPLICATE('a', (abs(CHECKSUM(newid())) % 100))
     FROM GENERATE_SERIES(1, @DefragmentationTestRowCount);

DECLARE @i int = 1
 
 WHILE @i <= 10 
 BEGIN 

 MERGE INTO [Fragmented] 
   USING (SELECT value as Id, REPLICATE('a', (abs(CHECKSUM(newid())) % 100)) AS NewText
     FROM GENERATE_SERIES(1, @DefragmentationTestRowCount)) NewRandomValues 
      ON [Fragmented].Id = NewRandomValues.Id
WHEN MATCHED THEN
   UPDATE 
      SET VariableSizeText = NewRandomValues.NewText; 
   SET @i += 1;
 END
END