CREATE TABLE AUTHORS(
    au_id INT PRIMARY KEY,
    au_lname VARCHAR(50),
    au_fname VARCHAR(50),
    phone INT,
    address VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    zip INT,
    contract INT
) -- CREATE DUMMY DATA
INSERT INTO
    AUTHORS
VALUES
    (
        1,
        'Horas',
        'Siregar',
        123456,
        'Jl. Segar II',
        'Pekanbaru',
        'Riau',
        28281,
        1
    ) 
    
-- Create Trigger
    CREATE TRIGGER trgUpdateAuthors ON Authors
    AFTER UPDATE 
    AS 
    SELECT 'Description' = 'The Inserted Table'
    SELECT * FROM Inserted
    SELECT 'Description' = 'The Deleted Table'
    SELECT * FROM Deleted

-- jalankan trigger
-- Update the au_fname from Horas to Amsal
UPDATE AUTHORS SET au_fname = 'Amsal' WHERE au_id = 1

-- Tes rowcount
SELECT * FROM AUTHORS
SELECT @@ROWCOUNT
GO
SELECT * FROM AUTHORS
IF @@ROWCOUNT > 0
    PRINT 'Then-part : ' + CAST(@@ROWCOUNT AS VARCHAR(10))
ELSE
    PRINT 'Else-part 0'