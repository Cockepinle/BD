CREATE DATABASE Bicycle_shop;
GO
USE Bicycle_shop;
GO

CREATE TABLE Number_of_speeds(
  ID_Number_of_speeds int primary key identity (1,1),
  Typets int NOT NULL
);
GO

CREATE TABLE Warranty(
  ID_Warranty INT PRIMARY KEY IDENTITY (1,1),
  Warranty varchar(10) NOT NULL
);
GO


CREATE TABLE Typet(
  ID_Typet int primary key identity (1,1),
  Typet varchar(10) NOT NULL
);
GO

CREATE TABLE Colour(
  ID_Colour int primary key identity (1,1),
  Colour varchar(10) NOT NULL
);
GO

CREATE TABLE Country(
  ID_Country int primary key identity (1,1),
  Country varchar(10) NOT NULL
);
GO

CREATE TABLE Stamp(
  ID_Stamp int primary key identity (1,1),
  Stamp varchar(10) NOT NULL
);
GO

CREATE TABLE Position(
  ID_Position int primary key identity (1,1),
  Position varchar(20) NOT NULL,
  Zarplata int NOT NULL
);
GO

CREATE TABLE Employee(
  ID_Employee int primary key identity (1,1),
  Surname varchar(10) NOT NULL,
  First_name varchar (20) NOT NULL,
  Patronymic varchar (20),
  Position_ID int NOT NULL,
  FOREIGN KEY (Position_ID) REFERENCES Position(ID_Position)
);
GO

CREATE TABLE Bicycle_shop(
  ID_Bicycle_shop int primary key identity (1,1),
    Employee_ID int NOT NULL,
  FOREIGN KEY (Employee_ID) REFERENCES Employee (ID_Employee),
    Stamp_ID int NOT NULL,
  FOREIGN KEY (Stamp_ID) REFERENCES Stamp (ID_Stamp),
    Country_ID int NOT NULL,
  FOREIGN KEY (Country_ID) REFERENCES Country (ID_Country),
    Colour_ID int NOT NULL,
  FOREIGN KEY (Colour_ID) REFERENCES Colour (ID_Colour),
    Typet_ID int NOT NULL,
  FOREIGN KEY (Typet_ID) REFERENCES Typet (ID_Typet),
    Number_of_speeds_ID int NOT NULL,
  FOREIGN KEY (Number_of_speeds_ID) REFERENCES Number_of_speeds (ID_Number_of_speeds),
      Warranty_ID int NOT NULL,
  FOREIGN KEY (Warranty_ID) REFERENCES Warranty (ID_Warranty),
    Price float NOT NULL,
    Quantity int NOT NULL
);
GO

  INSERT INTO Number_of_speeds (Typets)
  VALUES 
    (3),
    (9),
    (12),
    (2),
    (4);
GO

  INSERT INTO Warranty (Warranty)
  VALUES
    (N'6 месяцев'),
    (N'12 месяцев'),
    (N'6 месяцев'),
    (N'8 месяца'),
    (N'3 месяца');
GO

  INSERT INTO Typet (Typet)
  VALUES 
    (N'Горный'),
    (N'Городской'),
    (N'Детский'),
    (N'Взрослый'),
    (N'Горный');
GO

  INSERT INTO Colour (Colour)
  VALUES
    (N'Красный'),
    (N'Синий'),
    (N'Белый'),
    (N'Фиолетовый'),
    (N'Серый');
GO

  INSERT INTO Country (Country)
  VALUES 
    (N'Китай'),
    (N'Россия'),
    (N'Япония'),
    (N'Испания'),
    (N'Германия');
GO

  INSERT INTO Stamp (Stamp)
  VALUES 
    (N'Stels'),
    (N'SMART'),
    (N'GT'),
    (N'GT'),
    (N'SMART');
GO

  INSERT INTO Position (Position, Zarplata)
  VALUES 
    (N'Грузчик',10000),
    (N'Кладовщик',15000),
    (N'Заместитель',50000),
    (N'Заведущий',70000),
    (N'Грузчик',10000);
GO

  INSERT INTO Employee (Surname, First_name, Patronymic,Position_ID)
    VALUES 
    (N'Сидоров',N'Алексей',N'Олегович',1),
    (N'Землякова',N'Виктория',N'Сергеевна',2),
    (N'Грушева',N'Алина',N'Александровна',3),
    (N'Соболев',N'Дмитрий',N'Олегович',4),
    (N'Морозова',N'Екатерина',N'Васильевна',2),
    (N'Каблуков',N'Андрей',N'Романовия',1),
    (N'Мельникова',N'Алиса',N'Викторовна',3);
 GO
 
 SELECT *FROM Employee;

  INSERT INTO Bicycle_shop (Employee_ID, Stamp_ID, Country_ID, Colour_ID, Typet_ID, Number_of_speeds_ID, Warranty_ID, Price, Quantity)
  VALUES 
    (1,1,1,1,2,1,1,11069,50),
    (2,2,2,2,1,2,1,45390,67),
    (3,3,3,1,1,3,3,611286,50),
    (4,1,1,3,2,1,1,15798,77),
    (6,3,3,3,3,4,3,10567,67),
    (7,2,2,2,3,4,1,13467,89),
    (5,3,3,4,4,3,1,389678,20);
GO

CREATE VIEW CountingBicycles AS
SELECT Country.Country AS 'Страна',
Stamp.ID_Stamp AS 'Марка',
SUM(Bicycle_shop.Quantity) AS 'Общее количество',
SUM(Bicycle_shop.Quantity * Bicycle_shop.Price) AS 'Общая стоимость',
CASE
	WHEN SUM(Bicycle_shop.Quantity) < 20 THEN 'Низкие запасы товара'
	ELSE 'Достаточный запас товара'
END AS 'Статус запаса'
FROM Bicycle_shop
INNER JOIN Country ON Bicycle_shop.Country_ID = Country.ID_Country
INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
GROUP BY Country.Country, Stamp.ID_Stamp
GO

SELECT * FROM CountingBicycles
GO

CREATE VIEW SalaryWithBonuses AS
SELECT
Employee.ID_Employee AS 'ID сотрудника',
Employee.First_name + ' ' +	Employee.Patronymic + ' ' + Employee.Surname AS 'ФИО Сотрудников',
Position.Position AS 'Должность',
Position.Zarplata AS 'Зарплата',
CASE
	WHEN Position.Position IN ('Заведующий', 'Заместитель') THEN Position.Zarplata * 1.05
	ELSE Position.Zarplata * 1.03
END AS 'Зарплата с учетом начисления процентов'
FROM Employee
INNER JOIN Position ON Employee.Position_ID = Position.ID_Position
WITH CHECK OPTION;
GO

SELECT * FROM SalaryWithBonuses;


CREATE VIEW PriceRange AS
SELECT
CASE
	WHEN Price < 10000 THEN 'До 10 000 руб.'
	WHEN Price BETWEEN 10000 AND 20000 THEN '10 000 - 20 000 руб.'
	WHEN Price BETWEEN 20000 AND 30000 THEN '20 000 - 30 000 руб.'
	WHEN Price BETWEEN 30000 AND 40000 THEN '30 000 - 40 000 руб.'
	ELSE 'Свыше 40 000 руб.'
END AS 'Диапазон цен',
SUM(Bicycle_shop.Quantity) AS 'Количество',
SUM(Bicycle_shop.Quantity * Bicycle_shop.Price) AS 'Общая выручка/стоимость',
AVG(Bicycle_shop.Price) AS 'Средняя цена'
FROM Bicycle_shop
INNER JOIN Country ON Bicycle_shop.Country_ID = Country.ID_Country
INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
INNER JOIN Typet ON Bicycle_shop.Typet_ID = Typet.ID_Typet
INNER JOIN Colour ON Bicycle_shop.Colour_ID = Colour.ID_Colour
INNER JOIN Warranty ON Bicycle_shop.Warranty_ID = Warranty.ID_Warranty
GROUP BY CASE
	WHEN Price < 10000 THEN 'До 10 000 руб.'
	WHEN Price BETWEEN 10000 AND 20000 THEN '10 000 - 20 000 руб.'
	WHEN Price BETWEEN 20000 AND 30000 THEN '20 000 - 30 000 руб.'
	WHEN Price BETWEEN 30000 AND 40000 THEN '30 000 - 40 000 руб.'
	ELSE 'Свыше 40 000 руб.'
END;
GO

SELECT * FROM PriceRange;
GO

CREATE PROCEDURE DeleteBicycleProcedure
	@BicycleID int
AS
BEGIN
	DELETE FROM Bicycle_shop
	WHERE ID_Bicycle_shop = @BicycleID
END
GO

EXEC DeleteBicycleProcedure @BicycleID = 9;
GO

SELECT * FROM Bicycle_shop
GO

CREATE PROCEDURE GetBicycleProcedure
	@ID int
AS
BEGIN
	SELECT*
		FROM Bicycle_shop
		WHERE ID_Bicycle_shop = @ID;
END;
GO

EXEC GetBicycleProcedure @ID = 2;
GO 

CREATE PROCEDURE UpdateBicycleProcedure
	@ID int,
	@EmployeeID int,
	@StampID int,
	@CountryID int,
	@ColourID int,
	@TypetID int,
	@NumberOfSpeedsID int,
	@WarrantyID int,
	@Price float,
	@Quantity int
AS
BEGIN
	UPDATE Bicycle_shop
	SET
		Employee_ID = @EmployeeID,
		Stamp_ID = @StampID,
		Country_ID = @CountryID,
		Colour_ID = @ColourID,
		Typet_ID = @TypetID,
		Number_of_speeds_ID = @NumberOfSpeedsID,
		Warranty_ID = @WarrantyID,
		Price = @Price,
		Quantity = @Quantity
	WHERE ID_Bicycle_shop = @ID;
END;
GO

EXEC UpdateBicycleProcedure 
	@ID = 1, 
	@EmployeeID = 3, 
	@StampID = 2, 
	@CountryID = 1, 
	@ColourID = 3, 
	@TypetID = 2, 
	@NumberOfSpeedsID = 1, 
	@WarrantyID = 2, 
	@Price = 15000.25, 
	@Quantity = 30;
GO

SELECT * FROM Bicycle_shop
GO

CREATE FUNCTION GetAVGPriceTypeStampFunction(
	@Stamp VARCHAR(10),
	@Typet VARCHAR(10)
)
RETURNS float
AS
BEGIN 
	DECLARE @AveragePrice FLOAT;

	SELECT @AveragePrice = AVG(Price)
	FROM Bicycle_shop
    INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
    INNER JOIN Typet ON Bicycle_shop.Typet_ID = Typet.ID_Typet
    WHERE Stamp.Stamp = @Stamp AND Typet.Typet = @Typet;
  
  RETURN @AveragePrice;
END;
GO

SELECT dbo.GetAVGPriceTypeStampFunction('SMART','Детский');
GO
SELECT * FROM Bicycle_shop;
GO
SELECT * FROM Typet;
GO
SELECT * FROM Stamp;
GO

CREATE FUNCTION GetEmployeeByPositionFunction (
    @Position VARCHAR(20)
)
RETURNS TABLE
AS
RETURN (
    SELECT
        Employee.ID_Employee AS 'ID Сотрудника',
        Employee.Surname AS 'Фамилия',
        Employee.First_name AS 'Имя',
        Employee.Patronymic AS 'Отчество',
        Position.Zarplata AS 'Зарплата'
    FROM Employee
    INNER JOIN Position ON Employee.Position_ID = Position.ID_Position
    WHERE Position.Position = @Position
);
GO

SELECT * FROM dbo.GetEmployeeByPositionFunction('Заместитель');
GO

CREATE FUNCTION GetMinMaxBicycleSpeedFunction()
RETURNS TABLE
AS
RETURN (
  SELECT
    MIN(Number_of_speeds.Typets) AS 'Минимальная скорость велосипедов на складе',
    MAX(Number_of_speeds.Typets) AS 'Максимальная скорость велосипедов на складе'
  FROM Number_of_speeds 
);
GO

SELECT * FROM GetMinMaxBicycleSpeedFunction();
GO

CREATE TRIGGER UpdateEmployeeTrigger
ON Employee
AFTER UPDATE
AS
BEGIN
    DECLARE @OldSurname VARCHAR(10);
    DECLARE @OldFirstName VARCHAR(20);

    SELECT @OldSurname = e.Surname, @OldFirstName = e.First_name
    FROM Employee e
    INNER JOIN INSERTED i ON e.ID_Employee = i.ID_Employee;

    IF @OldSurname <> (SELECT Surname FROM INSERTED) OR @OldFirstName <> (SELECT First_name FROM INSERTED)
    BEGIN
        DECLARE @EmployeeID INT;
        SELECT @EmployeeID = ID_Employee FROM INSERTED;
        PRINT 'Данные о сотруднике ID ' + CAST(@EmployeeID AS VARCHAR) + ' изменены';
    END;
END;
GO

UPDATE Employee
SET Surname = 'ИвановA'
WHERE ID_Employee = 5;

SELECT * FROM Employee;

CREATE TRIGGER WarrantyReductionTrigger
ON Bicycle_shop
AFTER UPDATE
AS
BEGIN
  IF UPDATE(Warranty_ID) 
  BEGIN
    DECLARE @OldWarrantyID INT;
    DECLARE @NewWarrantyID INT;
    SELECT @OldWarrantyID = Warranty_ID FROM DELETED;
    SELECT @NewWarrantyID = Warranty_ID FROM INSERTED;

    IF @OldWarrantyID > @NewWarrantyID
    BEGIN
      RAISERROR('Нельзя уменьшать срок гарантии на велосипед!', 16, 1);
      ROLLBACK TRANSACTION;
    END;
  END;
END;
GO

SELECT * FROM Bicycle_shop;
GO
SELECT * FROM Warranty;
GO

UPDATE Bicycle_shop
SET Warranty_ID = 2
WHERE ID_Bicycle_shop = 7;
GO

CREATE TRIGGER UpdateStockTrigger
ON Bicycle_shop
AFTER INSERT
AS
BEGIN
  DECLARE @NewTypetID INT;
  DECLARE @NewQuantity INT;
  
  SELECT @NewTypetID = Typet_ID, @NewQuantity = Quantity FROM INSERTED;

  UPDATE Bicycle_shop
  SET Quantity = Quantity + @NewQuantity
  WHERE Typet_ID = @NewTypetID;
END;
GO

CREATE LOGIN Tuchka1 WITH PASSWORD = 'Tuchka123';
GO
CREATE USER Tuchka1 FOR LOGIN Tuchka1;
GO

CREATE LOGIN Sunny2 WITH PASSWORD = 'Sunny123';
GO
CREATE USER Sunny2 FOR LOGIN Sunny2;
GO

CREATE ROLE MYGROUPE;
GO
ALTER ROLE MYGROUPE ADD MEMBER Tuchka1;
GO
ALTER ROLE MYGROUPE ADD MEMBER Sunny2;
GO

GRANT SELECT ON Number_of_speeds TO Tuchka1;
GO
GRANT SELECT ON Warranty TO Tuchka1;
GO
GRANT SELECT ON Typet TO Tuchka1;
GO
GRANT SELECT ON Colour TO Tuchka1;
GO
GRANT SELECT ON Country TO Tuchka1;
GO
GRANT SELECT ON Stamp TO Tuchka1;
GO
GRANT SELECT ON Position TO Tuchka1;
GO
GRANT SELECT ON Employee TO Tuchka1;
GO
GRANT SELECT ON Bicycle_shop TO Tuchka1;
GO

GRANT SELECT, INSERT ON Number_of_speeds TO Sunny2;
GO
GRANT SELECT, INSERT ON Warranty TO Sunny2;
GO
GRANT SELECT, INSERT ON Typet TO Sunny2;
GO
GRANT SELECT, INSERT ON Colour TO Sunny2;
GO
GRANT SELECT, INSERT ON Country TO Sunny2;
GO
GRANT SELECT, INSERT ON Stamp TO Sunny2;
GO
GRANT SELECT, INSERT ON Position TO Sunny2;
GO
GRANT SELECT, INSERT ON Employee TO Sunny2;
GO
GRANT SELECT, INSERT ON Bicycle_shop TO Sunny2;
GO

SELECT * FROM Colour WHERE Colour.Colour LIKE 'с%'; 
GO

SELECT * FROM Colour WHERE Colour.Colour LIKE '%ый%'; 
GO

SELECT * FROM Employee WHERE Employee.First_name LIKE '_н%'; 
GO

SELECT * FROM Employee WHERE First_name LIKE '%а'; 
GO

SELECT * FROM Colour WHERE Colour LIKE 'с%й'; 
GO

EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE 
GO
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE
GO

EXEC xp_cmdshell 'bcp Bicycle_shop.dbo.Employee out "C:\Users\alepi\OneDrive\Рабочий стол\БД\ExportBicycle_shop.csv" -w -t, -T -S Cockepinle\SQLEXPRESS'
GO

SELECT * FROM Employee;
GO

EXEC xp_cmdshell 'bcp Bicycle_shop.dbo.Employee in "C:\Users\Public\Documents\SQL\MSSQL\ExportBicycle_shop.csv" -w -t, -T -S Cockepinle\SQLEXPRESS'
GO

EXEC xp_cmdshell 'bcp Bicycle_shop.dbo.Bicycle_shop out "C:\Users\alepi\OneDrive\Рабочий стол\БД\ExportBicycle_shop.csv" -w -t, -T -S Cockepinle\SQLEXPRESS'
GO

SELECT * FROM Employee;
GO

EXEC xp_cmdshell 'bcp Bicycle_shop.dbo.Bicycle_shop in "C:\Users\Public\Documents\SQL\MSSQL\ExportBicycle_shop.csv" -w -t, -T -S Cockepinle\SQLEXPRESS'
GO

BACKUP DATABASE Bicycle_shop TO DISK = 'Bicycle_shop.bak';
GO

USE master;
GO

DROP DATABASE Bicycle_shop;
GO

RESTORE DATABASE Bicycle_shop FROM DISK = 'Bicycle_shop.bak';
GO