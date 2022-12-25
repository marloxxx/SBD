DECLARE product_cursor CURSOR FOR
SELECT ProductID, PRODUCTNAME
FROM Products
WHERE CategoryID=2

OPEN product_cursor
-- Perform a fetch operation
FETCH NEXT FROM product_cursor
WHILE @@FETCH_STATUS = 0
BEGIN
    -- This is executed as long as the previous fetch succeededs.
    -- Print data if needed
    FETCH NEXT FROM product_cursor
END
CLOSE product_cursor
DEALLOCATE product_cursor

DECLARE product_cursor SCROLL CURSOR FOR
SELECT ProductID, PRODUCTNAME
FROM Products
WHERE CategoryID=2

OPEN product_cursor
-- Perform the first fetch operation
FETCH NEXT FROM product_cursor
FETCH FIRST FROM product_cursor
FETCH LAST FROM product_cursor
FETCH PRIOR FROM product_cursor
FETCH ABSOLUTE 2 FROM product_cursor
FETCH RELATIVE 3 FROM product_cursor
FETCH RELATIVE -3 FROM product_cursor

CLOSE product_cursor
DEALLOCATE product_cursor

DECLARE product_cursor INSENSITIVE CURSOR FOR
SELECT ProductID, PRODUCTNAME
FROM Products
WHERE CategoryID=2

OPEN product_cursor
-- update data in underlying tables
UPDATE Products SET PRODUCTNAME='Chef Antons Gumbo Mix-update' 
WHERE ProductID=5

-- Perform a fetch operation
FETCH NEXT FROM product_cursor
WHILE @@FETCH_STATUS = 0
BEGIN
    -- This is executed as long as the previous fetch succeededs.
    -- Print data if needed
    FETCH NEXT FROM product_cursor
END
CLOSE product_cursor
DEALLOCATE product_cursor