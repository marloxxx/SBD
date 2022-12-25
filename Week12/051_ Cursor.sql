/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

-- Exercise 1:
-- Create a players_cursor to display PLAYERNO, NAME and LEAGUENO. The result set of
-- cursor sorted by PLAYERNO (descending). The cursor fetch the first row and:

-- a. Print the first row as grid.
DECLARE players_cursor SCROLL CURSOR FOR
    SELECT PLAYERNO, NAME, LEAGUENO
    FROM PLAYERS
    ORDER BY PLAYERNO
OPEN players_cursor
FETCH FIRST FROM players_cursor
INTO @PLAYERNO, @NAME, @LEAGUENO
CLOSE players_cursor
DEALLOCATE players_cursor

-- b. Print the first row as text.
DECLARE @PLAYERNO INT
DECLARE @NAME CHAR(15)
DECLARE @LEAGUENO CHAR(4)
DECLARE players_cursor SCROLL CURSOR FOR
    SELECT PLAYERNO, NAME, LEAGUENO
    FROM PLAYERS
    ORDER BY PLAYERNO
OPEN players_cursor
FETCH FIRST FROM players_cursor
INTO @PLAYERNO, @NAME, @LEAGUENO
PRINT 'Player ' + CAST(@PLAYERNO AS VARCHAR(10)) + ' with name ' + @NAME + ' played in league no ' + @LEAGUENO
CLOSE players_cursor
DEALLOCATE players_cursor

-- Exercise 2:
-- Create a cursor which define a result set contains all players who lived in Stratford, Inglewood,
-- and Eltham town. Cursor fetch and print players data (PLAYERNO,NAME, TOWN) only for
-- player who lived in Eltham town.
DECLARE @PLAYERNO INT
DECLARE @NAME CHAR(15)
DECLARE @TOWN VARCHAR(30)
DECLARE players_cursor SCROLL CURSOR FOR
    SELECT PLAYERNO, NAME, TOWN
    FROM PLAYERS
OPEN players_cursor
FETCH NEXT FROM players_cursor
INTO @PLAYERNO, @NAME, @TOWN
WHILE @@FETCH_STATUS = 0
BEGIN
    IF @TOWN = 'Eltham'
    BEGIN
        PRINT 'Player ' + CAST(@PLAYERNO AS VARCHAR(10)) + ' with name ' + @NAME + ' lived in ' + @TOWN
    END
    FETCH NEXT FROM players_cursor
    INTO @PLAYERNO, @NAME, @TOWN
END 
CLOSE players_cursor
DEALLOCATE players_cursor

-- Exercise 3:
-- Create a cursor (using SCROLL CURSOR) which define a result set (PLAYERNO, NAME,
-- TEAMNO, WON, LOST) contains all players who won the matches. Cursor fetch dan display
-- data in the:
-- a. Last row
-- b. First row
-- c. Third row
-- d. Second row from the current row/cursor
-- e. Third row before the current row/cursor
DECLARE players_cursor SCROLL CURSOR FOR
    SELECT P.PLAYERNO, P.NAME, M.TEAMNO, M.WON, M.LOST
    FROM PLAYERS P, MATCHES M
    WHERE P.PLAYERNO = M.PLAYERNO AND M.WON > M.LOST
OPEN players_cursor
FETCH LAST FROM players_cursor
FETCH FIRST FROM players_cursor
FETCH RELATIVE 3 FROM players_cursor
FETCH PRIOR FROM players_cursor
FETCH RELATIVE -2 FROM players_cursor
CLOSE players_cursor
DEALLOCATE players_cursor

-- Exercise 4:
-- Create an update cursor which define a result set contains all players (PLAYERNO,NAME,
-- TOWN) who lived in Stratford, Inglewood, Eltham Town. Cursor fetches and updates town data
-- for the president who lived in Eltham become Jakarta. The result of this cursor is to print the
-- player data ( PLAYERNO, NAME, TOWN) after update executed.
DECLARE @PLAYERNO INT
DECLARE @NAME CHAR(15)
DECLARE @TOWN VARCHAR(30)
DECLARE players_cursor SCROLL CURSOR FOR
    SELECT PLAYERNO, NAME, TOWN
    FROM PLAYERS
    WHERE TOWN IN ('Stratford', 'Inglewood', 'Eltham')
OPEN players_cursor
FETCH NEXT FROM players_cursor
INTO @PLAYERNO, @NAME, @TOWN
WHILE @@FETCH_STATUS = 0
BEGIN
    IF @TOWN = 'Eltham'
    BEGIN
        UPDATE PLAYERS
        SET TOWN = 'Jakarta'
        WHERE PLAYERNO = @PLAYERNO
        SET @TOWN = 'Jakarta'
        PRINT 'Player ' + CAST(@PLAYERNO AS VARCHAR(10)) + ' with name ' + @NAME + ' lived in ' + @TOWN
    END
    FETCH NEXT FROM players_cursor
    INTO @PLAYERNO, @NAME, @TOWN
END
CLOSE players_cursor
DEALLOCATE players_cursor

-- Exercise 5:
-- Create a cursor which define a result set contains all products ordered by customer with contact
-- name Maria Anders (OrderID, ProductID, Quantity). If product id is 28 and amount is less
-- than 10, then update amount of product into 10. Print the information about all products ordered
-- by customer with contact name Maria Anders and all the modification made by cursor.
DECLARE @ORDERID INT
DECLARE @PRODUCTID INT
DECLARE @QUANTITY SMALLINT
DECLARE products_cursor SCROLL CURSOR FOR
    SELECT O.ORDERID, OD.PRODUCTID, OD.QUANTITY
    FROM ORDERS O, [ORDER DETAILS] OD, CUSTOMERS C
    WHERE O.ORDERID = OD.ORDERID AND O.CUSTOMERID = C.CUSTOMERID AND C.CONTACTNAME = 'Maria Anders'
OPEN products_cursor
FETCH NEXT FROM products_cursor
INTO @ORDERID, @PRODUCTID, @QUANTITY
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Order ' + CAST(@ORDERID AS VARCHAR(10)) + ' untuk product id ' + CAST(@PRODUCTID AS VARCHAR(10)) + ' dengan jumlah ' + CAST(@QUANTITY AS VARCHAR(10))
    IF @PRODUCTID = 28 AND @QUANTITY < 10
    BEGIN
        UPDATE [ORDER DETAILS]
        SET QUANTITY = 10
        WHERE ORDERID = @ORDERID AND PRODUCTID = @PRODUCTID
        SET @QUANTITY = 10
        PRINT 'Jumlah produk yang di order untuk produk id ' + CAST(@PRODUCTID AS VARCHAR(10)) + ' diubah menjadi ' + CAST(@QUANTITY AS VARCHAR(10))
    END
    FETCH NEXT FROM products_cursor
    INTO @ORDERID, @PRODUCTID, @QUANTITY
END
CLOSE products_cursor
DEALLOCATE products_cursor

-- Exercise 6:
-- Create a cursor which define a result set contains all orders where ShippedDate is null. For one
-- reason, shipper “Speedy Express” is bankrupt. Therefore, all orders which should be delivered
-- via shipper “Speedy Express” must be deleted from table (orders and [order details]). Create a
-- cursor to do this task and print the data like the picture below.
DECLARE @ORDERID INT
DECLARE @CUSTOMERID CHAR(5)
DECLARE @SHIPPERNAME VARCHAR(40)
DECLARE orders_cursor SCROLL CURSOR FOR
    SELECT O.ORDERID, S.SHIPPERID, S.COMPANYNAME
    FROM ORDERS O, SHIPPERS S
    WHERE O.SHIPVIA = S.SHIPPERID AND O.SHIPPEDDATE IS NULL
OPEN orders_cursor
FETCH NEXT FROM orders_cursor
INTO @ORDERID, @CUSTOMERID, @SHIPPERNAME
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Order ID: ' + CAST(@ORDERID AS VARCHAR(10)) + ' untuk customer id ' + @CUSTOMERID + ' dengan jasa kurir ' + @SHIPPERNAME + ' belum dikirim'
    IF @SHIPPERNAME = 'Speedy Express'
    BEGIN
        DELETE FROM [ORDER DETAILS]
        WHERE ORDERID = @ORDERID
        DELETE FROM ORDERS
        WHERE ORDERID = @ORDERID
        PRINT 'Order dengan order id ' + CAST(@ORDERID AS VARCHAR(10)) + ' telah dihapus dari table orders dan order details'
    END
    FETCH NEXT FROM orders_cursor
    INTO @ORDERID, @CUSTOMERID, @SHIPPERNAME
END
CLOSE orders_cursor
DEALLOCATE orders_cursor