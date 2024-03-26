 USE master;

BEGIN  -- DB INIT

IF  EXISTS (SELECT [Name] FROM sys.databases WHERE name = N'LocksTests')
BEGIN
	ALTER DATABASE [LocksTests] set single_user with rollback immediate
	DROP DATABASE [LocksTests];
END

CREATE DATABASE [LocksTests] ON
(
	NAME = DataSize_dat,
	FILENAME = '/var/opt/mssql/data/LocksTest.mdf',
    SIZE = 256 MB,
    FILEGROWTH = 64 MB)
LOG ON
(
	NAME = DataSize_log, 
	FILENAME = '/var/opt/mssql/data/LocksTest.ldf',
    SIZE = 256 MB,
    FILEGROWTH = 64 MB);
 
 ALTER DATABASE [LocksTests] SET RECOVERY FULL;
 ALTER DATABASE [LocksTests] SET ACCELERATED_DATABASE_RECOVERY = ON;
 ALTER DATABASE [LocksTests] SET ALLOW_SNAPSHOT_ISOLATION        ON;
 ALTER DATABASE [LocksTests] SET READ_COMMITTED_SNAPSHOT         ON;
 
 END

USE [LocksTests];

 BEGIN  -- Wait Stats
 CREATE TABLE dbo.[DummyTable]
 (
   Id int NOT NULL,
   Status tinyint NOT NULL DEFAULT 0,
   FixedSizeText char(999)  NOT NULL DEFAULT '',
   CONSTRAINT PK_Widgets PRIMARY KEY(Id)
 );
 
 INSERT dbo.[DummyTable](Id)
   SELECT value
     FROM GENERATE_SERIES(1, 500000); -- 500k
END