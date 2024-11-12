CREATE DATABASE Bicycle_shop;

CREATE TABLE Number_of_speeds(
  ID_Number_of_speeds SERIAL PRIMARY KEY,
  Typets INT NOT NULL
);

CREATE TABLE Warranty(
  ID_Warranty SERIAL PRIMARY KEY,
  Warranty VARCHAR(10) NOT NULL
);

CREATE TABLE Typet(
  ID_Typet SERIAL PRIMARY KEY,
  Typet VARCHAR(10) NOT NULL
);

CREATE TABLE Colour(
  ID_Colour SERIAL PRIMARY KEY,
  Colour VARCHAR(10) NOT NULL
);

CREATE TABLE Country(
  ID_Country SERIAL PRIMARY KEY,
  Country VARCHAR(10) NOT NULL
);

CREATE TABLE Stamp(
  ID_Stamp SERIAL PRIMARY KEY,
  Stamp VARCHAR(10) NOT NULL
);

CREATE TABLE Position(
  ID_Position SERIAL PRIMARY KEY,
  Position VARCHAR(20) NOT NULL,
  Zarplata INT NOT NULL
);

CREATE TABLE Employee(
  ID_Employee SERIAL PRIMARY KEY,
  Surname VARCHAR(10) NOT NULL,
  First_name VARCHAR(20) NOT NULL,
  Patronymic VARCHAR(20),
  Position_ID INT NOT NULL REFERENCES Position(ID_Position)
);

CREATE TABLE Bicycle_shop(
  ID_Bicycle_shop SERIAL PRIMARY KEY,
  Employee_ID INT NOT NULL REFERENCES Employee (ID_Employee),
  Stamp_ID INT NOT NULL REFERENCES Stamp (ID_Stamp),
  Country_ID INT NOT NULL REFERENCES Country (ID_Country),
  Colour_ID INT NOT NULL REFERENCES Colour (ID_Colour),
  Typet_ID INT NOT NULL REFERENCES Typet (ID_Typet),
  Number_of_speeds_ID INT NOT NULL REFERENCES Number_of_speeds (ID_Number_of_speeds),
  Warranty_ID INT NOT NULL REFERENCES Warranty (ID_Warranty),
  Price FLOAT NOT NULL,
  Quantity INT NOT NULL
);

  INSERT INTO Number_of_speeds (Typets)
  VALUES 
    (3),
    (9),
    (12),
    (2),
    (4);

  INSERT INTO Warranty (Warranty)
  VALUES
    (N'6 месяцев'),
    (N'12 месяцев'),
    (N'6 месяцев'),
    (N'8 месяца'),
    (N'3 месяца');

  INSERT INTO Typet (Typet)
  VALUES 
    (N'Горный'),
    (N'Городской'),
    (N'Детский'),
    (N'Взрослый'),
    (N'Горный');

  INSERT INTO Colour (Colour)
  VALUES
    (N'Красный'),
    (N'Синий'),
    (N'Белый'),
    (N'Фиолетовый'),
    (N'Серый');

  INSERT INTO Country (Country)
  VALUES 
    (N'Китай'),
    (N'Россия'),
    (N'Япония'),
    (N'Испания'),
    (N'Германия');

  INSERT INTO Stamp (Stamp)
  VALUES 
    (N'Stels'),
    (N'SMART'),
    (N'GT'),
    (N'GT'),
    (N'SMART');

  INSERT INTO Position (Position, Zarplata)
  VALUES 
    (N'Грузчик',10000),
    (N'Кладовщик',15000),
    (N'Заместитель',50000),
    (N'Заведущий',70000),
    (N'Грузчик',10000);

  INSERT INTO Employee (Surname, First_name, Patronymic,Position_ID)
    VALUES 
    (N'Сидоров',N'Алексей',N'Олегович',1),
    (N'Землякова',N'Виктория',N'Сергеевна',2),
    (N'Грушева',N'Алина',N'Александровна',3),
    (N'Соболев',N'Дмитрий',N'Олегович',4),
    (N'Морозова',N'Екатерина',N'Васильевна',2),
    (N'Каблуков',N'Андрей',N'Романовия',1),
    (N'Мельникова',N'Алиса',N'Викторовна',3);
 
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
	
CREATE VIEW CountingBicycles AS
SELECT Country.Country AS "Страна",
Stamp.ID_Stamp AS "Марка",
SUM(Bicycle_shop.Quantity) AS "Общее количество",
SUM(Bicycle_shop.Quantity * Bicycle_shop.Price) AS "Общая стоимость",
CASE
	WHEN SUM(Bicycle_shop.Quantity) < 20 THEN 'Низкие запасы товара'
	ELSE 'Достаточный запас товара'
END AS "Статус запаса"
FROM Bicycle_shop
INNER JOIN Country ON Bicycle_shop.Country_ID = Country.ID_Country
INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
GROUP BY Country.Country, Stamp.ID_Stamp

SELECT * FROM CountingBicycles

CREATE VIEW SalaryWithBonuses AS
SELECT
Employee.ID_Employee AS "ID сотрудника",
Employee.First_name || ' ' || Employee.Patronymic || ' ' || Employee.Surname AS "ФИО Сотрудников",
Position.Position AS "Должность",
Position.Zarplata AS "Зарплата",
CASE
	WHEN Position.Position IN ('Заведующий', 'Заместитель') THEN Position.Zarplata * 1.05
	ELSE Position.Zarplata * 1.03
END AS "Зарплата с учетом начисления процентов"
FROM Employee
INNER JOIN Position ON Employee.Position_ID = Position.ID_Position;

SELECT * FROM SalaryWithBonuses;

CREATE VIEW PriceRange AS
SELECT
CASE
	WHEN Price < 10000 THEN 'До 10 000 руб.'
	WHEN Price BETWEEN 10000 AND 20000 THEN '10 000 - 20 000 руб.'
	WHEN Price BETWEEN 20000 AND 30000 THEN '20 000 - 30 000 руб.'
	WHEN Price BETWEEN 30000 AND 40000 THEN '30 000 - 40 000 руб.'
	ELSE 'Свыше 40 000 руб.'
END AS "Диапазон цен",
SUM(Bicycle_shop.Quantity) AS "Количество",
SUM(Bicycle_shop.Quantity * Bicycle_shop.Price) AS "Общая выручка/стоимость",
AVG(Bicycle_shop.Price) AS "Средняя цена"
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

SELECT * FROM PriceRange;

CREATE OR REPLACE PROCEDURE DeleteEmployeeByIdProcedure(
    IN EmployeeID int
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Employee
    WHERE ID_Employee = EmployeeID;
END $$;

SELECT * FROM Employee;
CALL DeleteEmployeeByIdProcedure(8);

CREATE OR REPLACE PROCEDURE InsertEmployeeProcedure(
	IN Surname varchar(20),
	IN First_name varchar(20),
	IN Patronymic varchar(20),
	IN Position_ID int
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO Employee (Surname, First_name, Patronymic, Position_ID)
	VALUES (Surname, First_name, Patronymic, Position_ID);
END $$;

CALL InsertEmployeeProcedure(
	'Лепилина', 'Анастасия', 'Сергеевна', 1
);

SELECT * FROM Employee;

CREATE OR REPLACE PROCEDURE UpdateEmployeePositionProcedure(
    IN EmployeeID int,
    IN NewPositionID int
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Employee
    SET Position_ID = NewPositionID
    WHERE ID_Employee = EmployeeID;
END $$;

CALL UpdateEmployeePositionProcedure(
	1 , 2
);

SELECT * FROM Employee;

CREATE OR REPLACE FUNCTION GetBrandPriceAndTotalFunction()
	RETURNS TABLE(Brand VARCHAR, TotalBicycles BIGINT, TotalQuantity BIGINT, AveragePrice NUMERIC)
	LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT Stamp.Stamp AS Brand, 
       COUNT(*) AS TotalBicycles,
       SUM(Quantity) AS TotalQuantity,
       AVG(Bicycle_shop.Price)::NUMERIC AS AveragePrice
FROM Bicycle_shop
INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
GROUP BY Stamp.Stamp;
END $$;

SELECT * FROM GetBrandPriceAndTotalFunction();

CREATE OR REPLACE FUNCTION GetAverageSalaryByPositionFunction(PositionParam VARCHAR(20))
	RETURNS TABLE(AvgSalary NUMERIC, PositionName VARCHAR(20))
	LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT AVG(Position.Zarplata), Position.Position
FROM Employee
INNER JOIN Position ON Employee.Position_ID = Position.ID_Position
WHERE Position.Position = PositionParam
GROUP BY Position.Position;
END $$;

SELECT * FROM GetAverageSalaryByPositionFunction('Заместитель');--вторая

CREATE OR REPLACE FUNCTION GetTotalBicyclesByBrand(StampID INTEGER)
	RETURNS TABLE (Total_Quantity INTEGER, Average_Price DECIMAL)
	LANGUAGE plpgsql
AS $$
DECLARE
  total_quantity INTEGER;
  average_price DECIMAL;
BEGIN
  SELECT SUM(Quantity), AVG(Price)
  INTO total_quantity, average_price
  FROM Bicycle_shop
  WHERE Stamp_ID = StampID;

  RETURN QUERY
  SELECT total_quantity, average_price;
END $$;

SELECT * FROM GetTotalBicyclesByBrand(1);

CREATE OR REPLACE FUNCTION HandleBicycleShopChanges()
	RETURNS TRIGGER
	LANGUAGE plpgsql
AS $$
DECLARE
  total_quantity INTEGER;
  average_price DECIMAL;
BEGIN
  SELECT * INTO total_quantity, average_price
  FROM GetTotalBicyclesByBrand(NEW.Stamp_ID);
  RETURN NEW;
END $$;

CREATE TRIGGER HandleBicycleShopChangesTriggerFunction
AFTER INSERT OR UPDATE OR DELETE ON Bicycle_shop
FOR EACH ROW
EXECUTE FUNCTION HandleBicycleShopChanges();--третья функция

UPDATE Bicycle_shop
SET Quantity = 10, Price = 12
WHERE Stamp_ID = 1;
SELECT * FROM Bicycle_shop;
SELECT * FROM GetTotalBicyclesByBrand(1);

CREATE OR REPLACE FUNCTION PriceMultiplierFunctionTrigger()
	RETURNS TRIGGER 
	LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.Stamp_ID IS NOT NULL THEN
        NEW.Price = NEW.Price * 100;
        IF NEW.Price < 10000 THEN
            RAISE EXCEPTION 'Цена после умножения будет меньше 10 000. Пожалуйста, укажите более высокую цену.';
        END IF;
    END IF;
    RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER PriceMultiplierTrigger
BEFORE INSERT OR UPDATE ON Bicycle_shop
FOR EACH ROW
EXECUTE FUNCTION PriceMultiplierFunctionTrigger();

UPDATE Bicycle_shop SET Price = 2 WHERE ID_Bicycle_shop = 1;
SELECT * FROM Bicycle_shop;

CREATE OR REPLACE FUNCTION NameCapitalizationFunction()
	RETURNS TRIGGER 
	LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.First_name IS NULL THEN
    RAISE EXCEPTION 'Имя было не заполнено';
  END IF;

  IF NEW.Patronymic IS NULL THEN
    RAISE EXCEPTION 'Отчество было не заполнено';
  END IF;

  IF NEW.Surname IS NULL THEN
    RAISE EXCEPTION 'Фамилия была не заполнена';
  END IF;

  IF UPPER(LEFT(NEW.First_name, 1)) != LEFT(NEW.First_name, 1) THEN
    RAISE EXCEPTION 'Имя должно начинаться с заглавной буквы';
  END IF;

  NEW.First_name := CONCAT(UPPER(LEFT(NEW.First_name, 1)), LOWER(SUBSTRING(NEW.First_name, 2)));
  NEW.Patronymic := CONCAT(UPPER(LEFT(NEW.Patronymic, 1)), LOWER(SUBSTRING(NEW.Patronymic, 2)));
  NEW.Surname := CONCAT(UPPER(LEFT(NEW.Surname, 1)), LOWER(SUBSTRING(NEW.Surname, 2)));
  RETURN NEW;

EXCEPTION
  WHEN others THEN
    RAISE EXCEPTION 'Ошибка в функции NameCapitalizationFunction: %', SQLERRM;
END $$;

CREATE OR REPLACE TRIGGER NameCapitalizationTrigger
BEFORE INSERT ON Employee
FOR EACH ROW
EXECUTE FUNCTION NameCapitalizationFunction();

INSERT INTO Employee (First_name, Patronymic, Surname) VALUES ('john', 'doe', 'smith');

CREATE OR REPLACE FUNCTION RestrictPositionNameFunction()
	RETURNS TRIGGER
    LANGUAGE plpgsql 
AS $$
BEGIN
  IF NOT EXISTS (SELECT * FROM Position WHERE Position = CAST(NEW.Position_ID AS character varying)) THEN
    RAISE EXCEPTION 'Для сотрудника указана неверная должность. Пожалуйста, выберите существующую должность.';
  END IF;
  RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER RestrictPositionTrigger
BEFORE INSERT ON Employee
FOR EACH ROW
EXECUTE FUNCTION RestrictPositionFunction();

INSERT INTO Employee (First_name, Patronymic, Surname, Position_Name) VALUES ('Alice', 'Doe', 'Smith', 999);
SELECT * FROM Employee;--третий триггер

SELECT * FROM Employee WHERE First_name LIKE '%а';
SELECT * FROM Employee WHERE Employee.First_name LIKE '_л%';
SELECT * FROM Colour WHERE Colour.Colour LIKE '%ий%';
SELECT * FROM Colour WHERE Colour.Colour LIKE 'С%';

CREATE ROLE groupss;

CREATE ROLE user1 LOGIN;
ALTER ROLE user1 WITH PASSWORD 'password1';
CREATE ROLE user2 LOGIN;
ALTER ROLE user1 WITH PASSWORD 'password1';
GRANT groupss TO user1, user2;

GRANT INSERT, SELECT ON ALL TABLES IN SCHEMA public TO user1;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user2;

COPY (SELECT Position, Zarplata FROM Position) TO 'C:\Client\ExportPosition.csv' WITH CSV HEADER DELIMITER ',';
COPY Position (Position, Zarplata) FROM 'C:\Client\ExportPosition.csv' WITH CSV HEADER DELIMITER ',';

COPY (SELECT Employee_ID, Stamp_ID, Country_ID, Colour_ID, Typet_ID, Number_of_speeds_ID, Warranty_ID, Price, Quantity FROM Bicycle_shop) TO 'C:\Client\ExportBy.csv' WITH CSV HEADER DELIMITER ',';
COPY Bicycle_shop (Employee_ID, Stamp_ID, Country_ID, Colour_ID, Typet_ID, Number_of_speeds_ID, Warranty_ID, Price, Quantity) FROM 'C:\Client\ExportBy.csv' WITH CSV HEADER DELIMITER ',';