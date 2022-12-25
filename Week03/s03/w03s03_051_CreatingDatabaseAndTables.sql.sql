/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

-- Exercise 1. Creating the Tennis Database
-- Task-1
-- Write and execute a statement that creates a Tennis database by using the parameters
-- specification given in Table below. Note that for value of path files (Operating System
-- Data File Name and Operating System Log File Name),you can change the Path of
-- those files, but please do keep the Size Parameter the same as given in the table in
-- order to Save Disk Space.

CREATE DATABASE TennisDB
    ON
    PRIMARY (NAME = TennisDBPrimary,
    FILENAME = 'D:\SBD\Week03\s03\TennisDB.mdf',
    SIZE = 10MB,
    MAXSIZE = 20MB,
    FILEGROWTH = 20%),
    (NAME = TennisDBSecondary,
    FILENAME = 'D:\SBD\Week03\s03\TennisDB.ndf',
    SIZE = 5MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 20%)
    LOG ON
    (NAME = TennisDBLog,
    FILENAME = 'D:\SBD\Week03\s03\TennisDB.ldf',
    SIZE = 30MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 20%)

-- Task-2
-- After creating the Tennis Database, view the Information (Metadata) of database to verify
-- that the database was created.
sp_helpdb TennisDB

-- Exercise 2. Managing the Growth Files
-- Task-1
-- Write and execute a statement to increase the maximum size of the TennisDBLog to 60
-- megabytes (60 MB)
ALTER DATABASE TennisDB
    MODIFY FILE (NAME = 'TennisDBLog', MAXSIZE = 60MB)
GO
-- Task-2
-- After modifying/ Altering the Tennis Database view the Information (Metadata) of Tennis
-- Database to verify that the change is applied.
sp_helpdb TennisDB
-- Task-3
-- Repeat the Task-1 to modify the size of database and make it as previous. What do you
-- find?
-- Ketika perintah pada task 1 di eksekusi maka ukuran dari maximum size akan kembali seperti semula, yaitu menjadi 50MB atau 51200KB
ALTER DATABASE TennisDB
	MODIFY FILE (NAME = TennisDBLog, MAXSIZE = 50MB)
GO

-- Exercise 3. Adding Database Files
-- Task-1
-- Add a Secondary Data file to the Tennis Database by using the parameters specification
-- given in Table below.

ALTER DATABASE TennisDB
	ADD FILE(NAME = TennisDBSecondary2,
	FILENAME = 'D:\2022\SBD\Week03\s03\TennisDB2.ndf',
	SIZE = 5MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 20%)
GO

-- Task-2
-- Creates a file group to the Tennis Database and adds two 5 MB secondary files to the file
-- group. The name of the file group is TennisGroup. The names of the two secondary files
-- are TennisDB_1 and TennisDB_2. The maximum size for the each file is 10 MB and the growth incremental is 1 MB.
ALTER DATABASE TennisDB
    ADD FILEGROUP TennisGroup
GO

ALTER DATABASE TennisDB
ADD FILE(NAME = TennisDB_1,
    FILENAME = 'D:\2022\SBD\Week03\s03\TennisDB_1.ndf',
    SIZE = 5MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 1MB),
    (NAME = TennisDB_2,
    FILENAME = 'D:\2022\SBD\Week03\s03\TennisDB_2.ndf',
    SIZE = 5MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 1MB)
GO

-- Task-3
-- After applying the file group on Tennis Database, remove TennisDB_2 file from the
-- database.
ALTER DATABASE TennisDB
    REMOVE FILE TennisDB_2
GO
-- Exercise 4. Create Tables and Inserting Data
-- Task – 1
-- Create all President Tables that give in above Conceptual Data Model. Follow tables’ specification given in Table 1 until Table 5.

    -- CREATE ALL TABLE
    CREATE TABLE PLAYERS(
        PLAYERNO INT NOT NULL,
        NAME CHAR(15) NOT NULL,
        INITIALS CHAR(3) NOT NULL,
        BIRTH_DATE DATE,
        SEX CHAR(1) NOT NULL,
        JOINED SMALLINT NOT NULL,
        STREET VARCHAR(30) NOT NULL,
        HOUSENO CHAR(4),
        POSTCODE CHAR(6),
        TOWN VARCHAR(30) NOT NULL,
        PHONENO CHAR(13),
        LEAGUENO CHAR(4)
    )

    CREATE TABLE TEAMS(
        TEAMNO INTEGER NOT NULL,
        PLAYERNO INTEGER NOT NULL,
        DIVISION CHAR(6) NOT NULL
    )

    CREATE TABLE MATCHES(
        MATCHNO INTEGER NOT NULL,
        TEAMNO INTEGER NOT NULL,
        PLAYERNO INTEGER NOT NULL,
        WON SMALLINT NOT NULL,
        LOST SMALLINT NOT NULL
    )

    CREATE TABLE PENALTIES(
        PAYMENTNO INTEGER NOT NULL,
        PLAYERNO INTEGER NOT NULL,
        PAYMENT_DATE DATE NOT NULL,
        AMOUNT DECIMAL(7,2) NOT NULL
    )

    CREATE TABLE COMMITTEE_MEMBERS(
        PLAYERNO INTEGER NOT NULL,
        BEGIN_DATE DATE NOT NULL,
        END_DATE DATE,
        POSITION CHAR(20)
    )

-- CREATE PRIMARY KEY AND FOREIGN KEY
ALTER TABLE PLAYERS
ADD CONSTRAINT PK_PLAYERS PRIMARY KEY (PLAYERNO)

ALTER TABLE TEAMS
ADD CONSTRAINT PK_TEAMNO PRIMARY KEY (TEAMNO)

ALTER TABLE TEAMS
ADD FOREIGN KEY (TEAMNO) REFERENCES PLAYERS(PLAYERNO)

ALTER TABLE MATCHES
ADD CONSTRAINT PK_MATCHNO PRIMARY KEY (MATCHNO)

ALTER TABLE MATCHES
ADD FOREIGN KEY (MATCHNO) REFERENCES TEAMS(TEAMNO)

ALTER TABLE MATCHES
ADD FOREIGN KEY (MATCHNO) REFERENCES PLAYERS(PLAYERNO)

ALTER TABLE PENALTIES
ADD CONSTRAINT PK_PAYMENTNO PRIMARY KEY (PAYMENTNO)

ALTER TABLE PENALTIES
ADD FOREIGN KEY (PAYMENTNO) REFERENCES PLAYERS(PLAYERNO)

ALTER TABLE COMMITTEE_MEMBERS
ADD CONSTRAINT PK_PLAYERNO PRIMARY KEY (PLAYERNO, BEGIN_DATE)

ALTER TABLE COMMITTEE_MEMBERS
ADD FOREIGN KEY (PLAYERNO) REFERENCES PLAYERS(PLAYERNO)

-- CREATE CONSTRAINT
ALTER TABLE PLAYERS
ADD CONSTRAINT 
-- Task -2
-- Insert data to all tables.
INSERT INTO PLAYERS VALUES(1, 'John', 'J', '1990-01-01', 'M', 2010, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1')
INSERT INTO PLAYERS VALUES(2, 'Mary', 'M', '1990-01-01', 'F', 2010, 'Street 2', '2', '12345', 'Town 2', '1234567890', '2')
INSERT INTO PLAYERS VALUES(3, 'Peter', 'P', '1990-01-01', 'M', 2010, 'Street 3', '3', '12345', 'Town 3', '1234567890', '3')
INSERT INTO PLAYERS VALUES(4, 'Jane', 'J', '1990-01-01', 'F', 2010, 'Street 4', '4', '12345', 'Town 4', '1234567890', '4')
INSERT INTO PLAYERS VALUES(5, 'Tom', 'T', '1990-01-01', 'M', 2010, 'Street 5', '5', '12345', 'Town 5', '1234567890', '5')
INSERT INTO PLAYERS VALUES(6, 'Alice', 'A', '1990-01-01', 'F', 2010, 'Street 6', '6', '12345', 'Town 6', '1234567890', '6')
INSERT INTO PLAYERS VALUES(7, 'Bob', 'B', '1990-01-01', 'M', 2010, 'Street 7', '7', '12345', 'Town 7', '1234567890', '7')
INSERT INTO PLAYERS VALUES(8, 'Lily', 'L', '1990-01-01', 'F', 2010, 'Street 8', '8', '12345', 'Town 8', '1234567890', '8')
INSERT INTO PLAYERS VALUES(9, 'Jack', 'J', '1990-01-01', 'M', 2010, 'Street 9', '9', '12345', 'Town 9', '1234567890', '9')
INSERT INTO PLAYERS VALUES(10, 'Rose', 'R', '1990-01-01', 'F', 2010, 'Street 10', '10', '12345', 'Town 10', '1234567890', '10')

INSERT INTO TEAMS VALUES(1, 1, 'Div1')
INSERT INTO TEAMS VALUES(2, 2, 'Div2')
INSERT INTO TEAMS VALUES(3, 3, 'Div3')
INSERT INTO TEAMS VALUES(4, 4, 'Div4')
INSERT INTO TEAMS VALUES(5, 5, 'Div5')
INSERT INTO TEAMS VALUES(6, 6, 'Div6')
INSERT INTO TEAMS VALUES(7, 7, 'Div7')
INSERT INTO TEAMS VALUES(8, 8, 'Div8')
INSERT INTO TEAMS VALUES(9, 9, 'Div9')
INSERT INTO TEAMS VALUES(10, 10, 'Div10')

INSERT INTO MATCHES VALUES(1, 1, 1, 1, 0)
INSERT INTO MATCHES VALUES(2, 2, 2, 1, 0)
INSERT INTO MATCHES VALUES(3, 3, 3, 1, 0)
INSERT INTO MATCHES VALUES(4, 4, 4, 1, 0)
INSERT INTO MATCHES VALUES(5, 5, 5, 1, 0)
INSERT INTO MATCHES VALUES(6, 6, 6, 1, 0)
INSERT INTO MATCHES VALUES(7, 7, 7, 1, 0)
INSERT INTO MATCHES VALUES(8, 8, 8, 1, 0)
INSERT INTO MATCHES VALUES(9, 9, 9, 1, 0)
INSERT INTO MATCHES VALUES(10, 10, 10, 1, 0)

INSERT INTO PENALTIES VALUES(1, 1, '2010-01-01', 10.00)
INSERT INTO PENALTIES VALUES(2, 2, '2010-01-01', 10.00)
INSERT INTO PENALTIES VALUES(3, 3, '2010-01-01', 10.00)
INSERT INTO PENALTIES VALUES(4, 4, '2010-01-01', 10.00)
INSERT INTO PENALTIES VALUES(5, 5, '2010-01-01', 10.00)
INSERT INTO PENALTIES VALUES(6, 6, '2010-01-01', 10.00)
INSERT INTO PENALTIES VALUES(7, 7, '2010-01-01', 10.00)

INSERT INTO COMMITTEE_MEMBERS VALUES(1, '2010-01-01', '2010-01-01', 'President')
INSERT INTO COMMITTEE_MEMBERS VALUES(2, '2010-01-01', '2010-01-01', 'Vice President')
INSERT INTO COMMITTEE_MEMBERS VALUES(3, '2010-01-01', '2010-01-01', 'Secretary')
INSERT INTO COMMITTEE_MEMBERS VALUES(4, '2010-01-01', '2010-01-01', 'Treasurer')
INSERT INTO COMMITTEE_MEMBERS VALUES(5, '2010-01-01', '2010-01-01', 'Member')