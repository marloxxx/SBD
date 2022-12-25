-- 1 a 
-- Transaction A
-- Defaul isolation level : READ COMMITTED

-- start transaction
BEGIN TRAN
    UPDATE BUKU SET StockAvailable = 20
    WHERE id_buku = 'B6'

    WAITFOR DELAY '00:00:10'

ROLLBACK
-- end transaction
SELECT * FROM BUKU

-- Transaction B
-- Defaul isolation level : READ COMMITTED

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-- start transaction
SELECT id_buku, StockAvailable FROM BUKU 
    WHERE id_buku = 'B6'
-- end transaction

-- 1 b
-- Transaction A
-- Defaul isolation level : READ COMMITTED

-- start transaction
BEGIN TRAN
    UPDATE BUKU SET StockAvailable = 20
    WHERE id_buku = 'B6'

    WAITFOR DELAY '00:00:10'

ROLLBACK
-- end transaction
SELECT * FROM BUKU

-- Transaction B
-- Defaul isolation level : READ COMMITTED

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
-- start transaction
SELECT id_buku, StockAvailable FROM BUKU 
    WHERE id_buku = 'B6'
-- end transaction

-- 2 a
-- Transaction A
-- Defaul isolation level : READ COMMITTED

-- start transaction
BEGIN TRAN
    UPDATE BUKU SET StockAvailable = 20
    WHERE id_buku = 'B6'
-- end transaction

SELECT * FROM BUKU

-- Transaction B
-- Defaul isolation level : READ COMMITTED

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
-- start transaction
BEGIN TRAN
    SELECT id_buku, StockAvailable FROM BUKU 
    WHERE id_buku = 'B6'

    WAITFOR DELAY '00:00:10'

    SELECT id_buku, StockAvailable FROM BUKU 
    WHERE id_buku = 'B6'
COMMIT
-- end transaction

-- 2 b
-- Transaction A
-- Defaul isolation level : READ COMMITTED

-- start transaction
BEGIN TRAN
    UPDATE BUKU SET StockAvailable = 20
    WHERE id_buku = 'B6'
-- end transaction

SELECT * FROM BUKU

-- Transaction B
-- Defaul isolation level : READ COMMITTED

SET TRANSACTION ISOLATION LEVEL REPETABLE READ

-- start transaction
BEGIN TRAN
    SELECT id_buku, StockAvailable FROM BUKU 
    WHERE id_buku = 'B6'

    WAITFOR DELAY '00:00:10'

    SELECT id_buku, StockAvailable FROM BUKU 
    WHERE id_buku = 'B6'
COMMIT
-- end transaction

-- 3 a
-- Transaction A
-- Defaul isolation level : READ COMMITTED
-- start transaction
INSERT INTO Buku VALUES ('B7', 'Prisma', 'Pengenalan Mobile Programming', 10)
-- end transaction
SELECT * FROM Buku

-- Transaction B
-- Defaul isolation level : READ COMMITTED
SET TRANSACTION ISOLATION LEVEL REPETABLE READ

-- start transaction
BEGIN TRAN
    SELECT id_buku, StockAvailable FROM Buku 
    WAITFOR DELAY '00:00:10'
    SELECT id_buku, StockAvailable FROM Buku
COMMIT
-- end transaction

-- 3 b
-- Transaction A
-- Defaul isolation level : READ COMMITTED
-- start transaction
INSERT INTO Buku VALUES ('B8', 'Prisma', 'Pengenalan Mobile Programming', 10)
-- end transaction
SELECT * FROM Buku

-- Transaction B
-- Defaul isolation level : READ COMMITTED
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- start transaction
BEGIN TRAN
    SELECT id_buku, StockAvailable FROM Buku 
    WAITFOR DELAY '00:00:10'
    SELECT id_buku, StockAvailable FROM Buku
COMMIT
-- end transaction