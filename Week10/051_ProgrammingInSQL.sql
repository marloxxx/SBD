/*
    Nama	: Horas Marolop Amsal Siregar
    NIM		: 11321051
    Kelas	: 32TI2
 */

-- SQL Server 2014

-- Exercise 1: CASE..END statement
-- Execute SQL Statement below:
USE Northwind;
SELECT ProductName, CategoryName, UnitPrice
FROM Products INNER JOIN Categories 
ON Products.CategoryID = Categories.CategoryID;

-- Use Case…End statement to create t-sql query to display the products’ price and category as
-- Not Yet Priced, Cheap Products, Medium, and Expensive. The condition for categorization
-- is as follows:
-- If certain products not priced (the value in column price is empty/null), then ‘Not Yet Priced’.
-- If less than or equal 50, then ‘Cheap Product’.
-- If 50<price< =150, then ‘Medium’.
-- If >150 then ‘Expensive’.
-- The figure below depicts the result if your query executed successfully (result set: 77 rows).
-- Use join between products and categories table.

SELECT ProductName, CategoryName,
CASE
    WHEN UnitPrice IS NULL THEN 'Not Yet Priced'
    WHEN UnitPrice <= 50 THEN 'Cheap Product'
    WHEN UnitPrice > 50 AND UnitPrice <= 150 THEN 'Medium'
    WHEN UnitPrice > 150 THEN 'Expensive'
END AS Price_Category
FROM Products INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID ORDER BY UnitPrice;

-- Excersie 2: IF..THEN..ELSE statement

-- Task 1 Execute SQL Statement below:
USE TennisDB
DECLARE @CharTown CHAR(1), @Town CHAR(11)
SET @CharTown = 'E';
SET @Town = 
CASE @CharTown
	WHEN 'S' THEN 'Stratford'
	WHEN 'I' THEN 'Inglewood'
	WHEN 'E' THEN 'Eltham'
	WHEN 'M' THEN 'Mildhurst'
	WHEN 'D' THEN 'Douglas'
END;
SELECT * FROM PLAYERS
WHERE TOWN = @Town;

-- Modify the SQL statement above using IF…Then…Else….Statement.
DECLARE @CharTown CHAR(1), @Town CHAR(11)
SET @CharTown = 'E';
IF @CharTown = 'S' SET @Town = 'Stratford'
ELSE IF @CharTown = 'I' SET @Town = 'Inglewood'
ELSE IF @CharTown = 'E' SET @Town = 'Eltham'
ELSE IF @CharTown = 'M' SET @Town = 'Mildhurst'
ELSE IF @CharTown = 'D' SET @Town = 'Douglas'
SELECT * FROM PLAYERS
WHERE TOWN = @Town;

-- Task-2 Use TennisDB Database. Display in text field (not in grid->PRINT bukan SELECT), -- the information (playerno,name, nr_won) about the player who won more than 1 matches.
DECLARE @PlayerNo INT, @Name CHAR(15), @NrWon INT
SELECT @PlayerNo = P.PLAYERNO, @Name = P.NAME, @NrWon = COUNT(*)
FROM PLAYERS P INNER JOIN MATCHES M
ON P.PLAYERNO = M.PLAYERNO
GROUP BY P.PLAYERNO, P.NAME
HAVING COUNT(*) >= 3
PRINT 'Player Number adalah ' + CAST(@PlayerNo AS VARCHAR(10)) + ' dengan Player Name ' + @Name + ' NR_WON adalah ' + CAST(@NrWon AS VARCHAR(10))

-- Exercise 3: While...Statement
-- Execute sql statement below:
USE AdventureWorksLT2008;
SELECT * FROM SalesLT.Product;

-- Then, find the average of ListPrice:
SELECT AVG (ListPrice) FROM SalesLT.Product;
-- Then result are 744.5952. Consider the condition below and use while to build PL/SQL
-- statement for the condition. If the average ListPrice of product is less than $1000, use while to:
--  doubles the ListPrice for every products
--  If the maximum ListPrice is less than or equal to $4000, then WHILE loop restarts and
-- doubles the prices again. This loop continues doubling the prices until the maximum
-- price is greater than $4000, and then exits the WHILE loop and prints a message.

DECLARE @ListPrice FLOAT, @AvgListPrice FLOAT, @MaxListPrice FLOAT
SELECT @AvgListPrice = AVG(ListPrice) FROM SalesLT.Product
SELECT @MaxListPrice = MAX(ListPrice) FROM SalesLT.Product
SELECT @ListPrice = @AvgListPrice
WHILE @ListPrice < 1000
BEGIN
    UPDATE SalesLT.Product SET ListPrice = ListPrice * 2
    SELECT @MaxListPrice = MAX(ListPrice) FROM SalesLT.Product
    IF @MaxListPrice > 4000
    BEGIN
        BREAK
    END
END
PRINT 'Max List Price: ' + CAST(@MaxListPrice AS VARCHAR(10))