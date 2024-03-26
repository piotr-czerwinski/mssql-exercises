USE master;
GO

IF  EXISTS (SELECT [Name] FROM sys.databases WHERE name = N'DataSize')
BEGIN
	ALTER DATABASE [DataSize] set single_user with rollback immediate
	DROP DATABASE [DataSize];
END
GO