CREATE DATABASE Pract3;
USE Pract3;

CREATE TABLE Number_of_speeds(
  ID_Number_of_speeds INT PRIMARY KEY AUTO_INCREMENT,
  Typets INT NOT NULL
);

CREATE TABLE Warranty(
  ID_Warranty INT PRIMARY KEY AUTO_INCREMENT,
  Warranty VARCHAR(10) NOT NULL
);

CREATE TABLE Typet(
  ID_Typet INT PRIMARY KEY AUTO_INCREMENT,
  Typet VARCHAR(10) NOT NULL
);

CREATE TABLE Colour(
  ID_Colour INT PRIMARY KEY AUTO_INCREMENT,
  Colour VARCHAR(10) NOT NULL
);

CREATE TABLE Country(
  ID_Country INT PRIMARY KEY AUTO_INCREMENT,
  Country VARCHAR(10) NOT NULL
);

CREATE TABLE Stamp(
  ID_Stamp INT PRIMARY KEY AUTO_INCREMENT,
  Stamp VARCHAR(10) NOT NULL
);

CREATE TABLE Positions(
  ID_Positions INT PRIMARY KEY AUTO_INCREMENT,
  Positions VARCHAR(20) NOT NULL,
  Zarplata INT NOT NULL
);

CREATE TABLE Employee(
  ID_Employee INT PRIMARY KEY AUTO_INCREMENT,
  Surname VARCHAR(10) NOT NULL,
  First_name VARCHAR(20) NOT NULL,
  Patronymic VARCHAR(20),
  Positions_ID INT  NOT NULL,
  FOREIGN KEY (Positions_ID) REFERENCES Positions (ID_Positions)
);

CREATE TABLE Bicycle_shop(
  ID_Bicycle_shop INT PRIMARY KEY AUTO_INCREMENT,
  FOREIGN KEY (Employee_ID) REFERENCES Employee (ID_Employee),
    Employee_ID INT NOT NULL,
  FOREIGN KEY (Stamp_ID) REFERENCES Stamp (ID_Stamp),
    Stamp_ID INT NOT NULL,
  FOREIGN KEY (Country_ID) REFERENCES Country (ID_Country),
    Country_ID INT NOT NULL,
  FOREIGN KEY (Colour_ID) REFERENCES Colour (ID_Colour),
    Colour_ID INT NOT NULL,
  FOREIGN KEY (Typet_ID) REFERENCES Typet (ID_Typet),
    Typet_ID INT NOT NULL,
  FOREIGN KEY (Number_of_speeds_ID) REFERENCES Number_of_speeds (ID_Number_of_speeds),
    Number_of_speeds_ID INT NOT NULL,
  FOREIGN KEY (Warranty_ID) REFERENCES Warranty (ID_Warranty),
    Warranty_ID INT NOT NULL,
  Price FLOAT NOT NULL,
  Quantity INT NOT NULL
);

  INSERT INTO Number_of_speeds (Typets)
  VALUES	(3),
			(9),
			(12),
			(2),
			(4);

  INSERT INTO Warranty (Warranty)
  VALUES
		('6 месяцев'),
		('12 месяцев'),
		('6 месяцев'),
		('8 месяца'),
		('3 месяца');

  INSERT INTO Typet (Typet)
  VALUES 
		('Горный'),
		('Городской'),
		('Детский'),
		('Взрослый'),
		('Горный');

  INSERT INTO Colour (Colour)
  VALUES
		('Красный'),
		('Синий'),
		('Белый'),
		('Фиолетовый'),
		('Серый');

  INSERT INTO Country (Country)
  VALUES 
		('Китай'),
		('Россия'),
		('Япония'),
		('Испания'),
		('Германия');

  INSERT INTO Stamp (Stamp)
  VALUES 
		('Stels'),
		('SMART'),
		('GT'),
		('GT'),
		('SMART');

  INSERT INTO Positions (Positions, Zarplata)
  VALUES 
		('Грузчик',10000),
		('Кладовщик',15000),
		('Заместитель',50000),
		('Заведущий',70000),
		('Грузчик',10000);

  INSERT INTO Employee (Surname, First_name, Patronymic,Positions_ID)
  VALUES 
		('Сидоров','Алексей','Олегович',1),
		('Землякова','Виктория','Сергеевна',2),
		('Грушева','Алина','Александровна',3),
		('Соболев','Дмитрий','Олегович',4),
		('Морозова','Екатерина','Васильевна',2),
		('Каблуков','Андрей','Романовия',1),
		('Мельникова','Алиса','Викторовна',3);
 
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
        
CREATE OR REPLACE VIEW CountingBicycles AS
SELECT Country.Country AS 'Страна',
	Stamp.ID_Stamp AS 'Марка',
	SUM(Bicycle_shop.Quantity) AS 'Общее количество',
	SUM(Bicycle_shop.Quantity * Bicycle_shop.Price) AS 'Общая стоимость',
IF(SUM(Bicycle_shop.Quantity) < 20, 'Низкие запасы товара', 'Достаточный запас товара') AS 'Статус запаса'
FROM Bicycle_shop
	INNER JOIN Country ON Bicycle_shop.Country_ID = Country.ID_Country
	INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
	GROUP BY Country.Country, Stamp.ID_Stamp;

SELECT * FROM CountingBicycles;

CREATE OR REPLACE VIEW SalaryWithBonuses AS
SELECT
	Employee.ID_Employee AS 'ID сотрудника',
	CONCAT(Employee.First_name, ' ', Employee.Patronymic, ' ', Employee.Surname) AS 'ФИО Сотрудников',
	Positions.Positions AS 'Должность',
	Positions.Zarplata AS 'Зарплата',
IF(Positions.Positions IN ('Заведующий', 'Заместитель'), Positions.Zarplata * 1.05, Positions.Zarplata * 1.03) AS 'Зарплата с учетом начисления процентов'
FROM Employee
	JOIN Positions ON Employee.Positions_ID = Positions.ID_Positions;

SELECT * FROM SalaryWithBonuses;

CREATE OR REPLACE VIEW PriceRange AS
SELECT
CASE
    WHEN Price < 10000 THEN 'До 10 000 руб.'
    WHEN Price BETWEEN 10000 AND 20000 THEN '10 000 - 20 000 руб.'
    WHEN Price BETWEEN 20000 AND 30000 THEN '20 000 - 30 000 руб.'
    WHEN Price BETWEEN 30000 AND 40000 THEN '30 000 - 40 000 руб.'
    ELSE 'Свыше 40 000 руб.'
END AS `Диапазон цен`,
SUM(Bicycle_shop.Quantity) AS `Количество`,
SUM(Bicycle_shop.Quantity * Bicycle_shop.Price) AS `Общая выручка/стоимость`,
AVG(Bicycle_shop.Price) AS `Средняя цена`
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

DELIMITER //
CREATE PROCEDURE DseleteWarrantys(
	IN warranty_id INT
)
BEGIN
	DECLARE RowsAffected INT;
	
	SELECT COUNT(*) INTO RowsAffected FROM Warranty WHERE ID_Warranty = warranty_id;
	
	IF RowsAffected > 0 THEN
		DELETE FROM Warranty WHERE ID_Warranty = warranty_id;
		SELECT 'Удаление гарантии было успешным' AS Message;
	ELSE
		SELECT 'Гарантия с указанным идентификатором не найдена' AS Message;
	END IF;
END //
DELIMITER ;

CALL DseleteWarrantys(10);
SELECT * FROM Warranty;

DELIMITER //
CREATE PROCEDURE AddAgeToEmployeeAndInserts(IN surname VARCHAR(10), IN first_name VARCHAR(20), IN patronymic VARCHAR(20), IN positions_id INT, IN age INT, OUT Employee_ID INT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employee' AND COLUMN_NAME = 'Age') THEN
    ALTER TABLE Employee
    ADD COLUMN Age INT;
  END IF;

  INSERT INTO Employee (Surname, First_name, Patronymic, Positions_ID, Age)
  VALUES (surname, first_name, patronymic, positions_id, age);

  SET Employee_ID = LAST_INSERT_ID();

END//
DELIMITER ;
CALL AddAgeToEmployeeAndInserts('Я', 'Уже', 'Устала', 2, 30, @Employee_ID);
SELECT * FROM Employee;

DELIMITER //
CREATE PROCEDURE ChangeEmployeeSalary(IN EmployeeID INT, IN NewSalary INT)
BEGIN
    UPDATE Positions
    SET Zarplata = NewSalary
    WHERE ID_Positions = (SELECT Positions_ID FROM Employee WHERE ID_Employee = EmployeeID);
END //
DELIMITER ;
CALL ChangeEmployeeSalary(3, 50000);
SELECT * FROM Positions;

DELIMITER //
CREATE FUNCTION GetAVGPriceTypeStampFunction(
    Stamp VARCHAR(10),
    Typet VARCHAR(10)
)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN 
    DECLARE AveragePrice FLOAT;
    SELECT AVG(Price) INTO AveragePrice
    FROM Bicycle_shop
    INNER JOIN Stamp ON Bicycle_shop.Stamp_ID = Stamp.ID_Stamp
    INNER JOIN Typet ON Bicycle_shop.Typet_ID = Typet.ID_Typet
    WHERE Stamp.Stamp = Stamp AND Typet.Typet = Typet;
    
    RETURN AveragePrice;
END//
DELIMITER ;

SELECT GetAVGPriceTypeStampFunction('SMART','Детский');


DELIMITER //
CREATE FUNCTION GetEmployeeByPositionFunctionsssssss(
    Positions VARCHAR(20)
)
RETURNS BIGINT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE EmployeeID BIGINT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        RETURN NULL; 
    END;

    SELECT Employee.ID_Employee INTO EmployeeID
    FROM Employee
    INNER JOIN Positions ON Employee.Positions_ID = Positions.ID_Positions
    WHERE Positions.Positions = Positions;

    RETURN EmployeeID;
END;
DELIMITER ;
SELECT GetEmployeeByPositionFunctionsssssss('Заведущий');
SELECT * FROM Employee;

DELIMITER //
CREATE FUNCTION GetMinMaxBicycleSpeedFunctions()
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE MinSpeed INT;
    DECLARE MaxSpeed INT;
    
    SELECT MIN(Typets), MAX(Typets)
    INTO MinSpeed, MaxSpeed
    FROM Number_of_speeds;
    
    RETURN CONCAT('Минимальная скорость велосипедов на складе: ', MinSpeed, ', Максимальная скорость велосипедов на складе: ', MaxSpeed);
END//
DELIMITER ;
SELECT GetMinMaxBicycleSpeedFunctions();

DELIMITER //
CREATE TRIGGER CheckPriceTrigger
BEFORE INSERT ON Bicycle_shop
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Цена не может быть отрицательным значением';
    END IF;
END //
DELIMITER ;

INSERT INTO Bicycle_shop (Employee_ID, Stamp_ID, Country_ID, Colour_ID, Typet_ID, Number_of_speeds_ID, Warranty_ID, Price, Quantity) 
VALUES (1, 2, (SELECT ID_Country FROM Country WHERE Country = 'USA'), 3, 4, 5, 6, -1000.00, 10);

DELIMITER //
CREATE TRIGGER TypetTrigger
BEFORE DELETE ON Typet
FOR EACH ROW
BEGIN
    DECLARE cnt INT;
    SELECT COUNT(*) INTO cnt FROM Bicycle_shop WHERE Typet_ID = OLD.ID_Typet;
    IF cnt > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Нельзя удалять Typet с ассоциированными записями в Bicycle_shop';
    END IF;
END //
DELIMITER ;
DELETE FROM Typet WHERE ID_Typet = 1;

DELIMITER $$
CREATE TRIGGER CheckRequiredDataBeforeBicycleAdditionTrigger
BEFORE INSERT ON Bicycle_shop
FOR EACH ROW
BEGIN
    IF NEW.Employee_ID IS NULL OR NEW.Stamp_ID IS NULL OR NEW.Country_ID IS NULL OR NEW.Colour_ID IS NULL OR NEW.Typet_ID IS NULL OR NEW.Number_of_speeds_ID IS NULL OR NEW.Warranty_ID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Недостаточно данных для добавления велосипеда в магазин';
    END IF;
END $$
DELIMITER ;

INSERT INTO Bicycle_shop (Employee_ID, Stamp_ID, Country_ID, Colour_ID, Typet_ID, Number_of_speeds_ID, Warranty_ID, Price, Quantity) 
VALUES (1, 1, 1, NULL, 1, 1, 1, 500.00, 10);
