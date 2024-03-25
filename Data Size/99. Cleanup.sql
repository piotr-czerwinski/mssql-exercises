USE master;
GO

IF  EXISTS (SELECT [Name] FROM sys.databases WHERE name = N'DataTypes')
BEGIN
	ALTER DATABASE [DataTypes] set single_user with rollback immediate
	DROP DATABASE [DataTypes];
END
GO