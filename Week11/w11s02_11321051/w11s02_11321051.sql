/*     
       Nama : Horas Marolop Amsal Siregar 
       NIM : 11321051 Kelas : 32TI2 
*/

-- Exercise 1: Create a simple procedure with a simple select
-- Use TennisDB database to create a stored procedure to list in alphabetic order the names of players who has name have an ‘o’ as second character.
CREATE PROCEDURE ListPlayersWithO
AS
    SELECT * FROM PLAYERS WHERE NAME LIKE '_o%'
GO
EXEC ListPlayersWithO
GO

-- Exercise 2: Create a simple procedure with a complex select
-- A. Use TennisDB database. Create a stored procedure to list all player data (name, birth_date, and total number of their won). Order by name ascending order and secondly by birth_date.
CREATE PROCEDURE ListPlayersWithWon
AS
    SELECT NAME, BIRTH_DATE, SUM(WON) AS TOTAL_WON FROM PLAYERS P
    INNER JOIN MATCHES M ON P.PLAYERNO = M.PLAYERNO
    GROUP BY NAME, BIRTH_DATE
    ORDER BY NAME, BIRTH_DATE
GO
EXEC ListPlayersWithWon
GO

-- B. Use Northwind database. Create a stored procedure to list Order data (OrderID, Contact Name, Employee Name (first name + last name), OrderDate, ShippedDate, ShipperCompanyname).
CREATE PROCEDURE ListOrderData
AS
    SELECT O.OrderID, C.ContactName, E.FirstName + ' ' + E.LastName AS EmployeeName, O.OrderDate, O.ShippedDate, S.CompanyName 
    FROM Orders O INNER JOIN Customers C 
    ON O.CustomerID = C.CustomerID 
    INNER JOIN Employees E 
    ON O.EmployeeID = E.EmployeeID INNER JOIN Shippers S 
    ON O.ShipVia = S.ShipperID
GO
EXEC ListOrderData
GO

-- Exercise 3: Create a procedure to do insert, delete or update data
-- A. Use TennisDB database.
-- Create a stored procedure to insert new player to players table. All the player data used as
-- procedure parameter. If there is an error according to the input parameter, use block try
-- catch to print error message.
CREATE PROCEDURE InsertPlayer
    @PlayerNo int,
    @Name char(15),
    @Initials char(3),
    @BirthDate date,
    @Sex char(1),
    @Joined smallint,
    @Street varchar(30),
    @HouseNo char(4),
    @PostCode char(6),
    @Town varchar(30),
    @PhoneNo char(13),
    @LeagueNo char(4)
AS
BEGIN
    BEGIN TRY
        INSERT INTO PLAYERS VALUES (@PlayerNo, @Name, @Initials, @BirthDate, @Sex, @Joined, @Street, @HouseNo, @PostCode, @Town, @PhoneNo, @LeagueNo)
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO
EXEC InsertPlayer 100, 'Horas', 'HMS', '1994-01-01', 'M', 2014, 'Jl. Segar', '1', '123456', 'Bandung', '081234567890', '1'
GO

-- B. Use TennisDB database.
-- Create a stored procedure to delete one player from players table. Input parameter is player
-- name with default value is null. If procedure parameter is null or player name is not
-- available in table, then display all state data.
CREATE PROCEDURE DeletePlayer
    @Name char(15) = NULL
AS
BEGIN
    BEGIN TRY
        DELETE FROM PLAYERS WHERE NAME = @Name
    END TRY
    BEGIN CATCH
        SELECT * FROM PLAYERS
    END CATCH
END
GO
EXEC DeletePlayer 'Horas'
GO

-- 1. Create table berikut.
CREATE TABLE PerformanceIssue
(
    ID int IDENTITY NOT NULL,
    Status char(1) NOT NULL,
)
GO
-- Jika anda sebagai seorang database developer ingin mengisi table tersebut dengan 2000
-- record data dummy, dengan ketentuan: Jika baris berada pada record dengan kelipatan 2
-- maka status = A, tetapi jika tidak maka status = B. Buatlah sebuah stored procedure sesuai
-- dengan kondisi tersebut, dengan parameter adalah jumlah record yang akan di insert ke
-- dalam table.
CREATE PROCEDURE InsertPerformanceIssue
    @Count int
AS
BEGIN
    DECLARE @i int = 1
    WHILE @i <= @Count
    BEGIN
        IF @i % 2 = 0
            INSERT INTO PerformanceIssue VALUES ('A')
        ELSE
            INSERT INTO PerformanceIssue VALUES ('B')
        SET @i = @i + 1
    END
END
GO
EXEC InsertPerformanceIssue 2000
GO

-- 2. Masih ingat dengan tabel metadata SQL Server. Gunakan
-- INFORMATION_SCHEMA.TABLES dan INFORMATION_SCHEMA.COLUMNS
-- untuk task ini. Buatlah system store procedure (gunakan awalan sp_ penamaan procedure
-- nya) untuk menampilkan seluruh nama table dan nama kolom yang terdapat dalam
-- TennisDB.
CREATE PROCEDURE sp_ListTableAndColumn
AS
    SELECT T.TABLE_NAME, C.COLUMN_NAME 
    FROM INFORMATION_SCHEMA.TABLES T 
    INNER JOIN INFORMATION_SCHEMA.COLUMNS C 
    ON T.TABLE_NAME = C.TABLE_NAME 
    WHERE T.TABLE_CATALOG = 'TennisDB'
GO
EXEC sp_ListTableAndColumn
GO