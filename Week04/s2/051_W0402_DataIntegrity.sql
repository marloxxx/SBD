/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

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
    TEAMNO INTEGER NOT NULL PRIMARY KEY,
    PLAYERNO INTEGER NOT NULL,
    DIVISION CHAR(6) NOT NULL
)

CREATE TABLE MATCHES(
    MATCHNO INTEGER NOT NULL PRIMARY KEY,
    TEAMNO INTEGER NOT NULL,
    PLAYERNO INTEGER NOT NULL,
    WON SMALLINT NOT NULL,
    LOST SMALLINT NOT NULL
)

CREATE TABLE PENALTIES(
    PAYMENTNO INTEGER NOT NULL PRIMARY KEY,
    PLAYERNO INTEGER NOT NULL,
    PAYMENT_DATE DATE NOT NULL,
    AMOUNT DECIMAL(7,2) NOT NULL
)

CREATE TABLE COMMITTEE_MEMBERS(
    PLAYERNO INTEGER NOT NULL PRIMARY KEY,
    BEGIN_DATE DATE NOT NULL,
    END_DATE DATE,
    POSITION CHAR(20)
)

-- Exercise 1: Creating check constraint
-- Task-1
-- Create a check constraint in Players table to make Name and Initials value without empty
-- string (‘’).
-- Display information about Players table and try to insert value to implementing the constraint.
ALTER TABLE PLAYERS
    ADD CONSTRAINT CHK_NAME_INITIALS CHECK (NAME <> '' AND INITIALS <> '')
GO
sp_help PLAYERS
INSERT INTO PLAYERS VALUES(1, 'Horas Marolop Amsal', 'HMA', '2003-03-26', 'M', 2010, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1')
INSERT INTO PLAYERS VALUES(2, '', '', '1990-01-01', 'F', 2010, 'Street 2', '2', '12345', 'Town 2', '1234567890', '2')


-- Task-2
-- Create a check constraint in Players table to check Joined must be greater or equal than 1970
-- (year which the club was founded).
-- Display information about Players table and try to insert value to implementing the constraint.
ALTER TABLE PLAYERS
    ADD CONSTRAINT CHK_JOINED CHECK (JOINED >= 1970)
GO
sp_help PLAYERS
INSERT INTO PLAYERS VALUES(3, 'Horas Marolop Amsal', 'HMA', '2003-03-26', 'M', 1969, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1')
INSERT INTO PLAYERS VALUES(4, 'Horas Marolop Amsal', 'HMA', '2003-03-26', 'M', 1970, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1')

-- Task -3
-- Create a check constraint in Committee_Members table to check Entries for Position
-- column. The valid values for position are ‘Chairman’, ‘Member’, ‘Secretary’, ‘Treasurer’.
-- Display information about Committee_Members table and try to insert value to implementing
-- the constraint.
ALTER TABLE COMMITTEE_MEMBERS
    ADD CONSTRAINT CHK_POSITION CHECK (POSITION IN ('Chairman', 'Member', 'Secretary', 'Treasurer'))
GO
sp_help COMMITTEE_MEMBERS
INSERT INTO COMMITTEE_MEMBERS VALUES(1, '2003-03-26', NULL, 'Chairman')
INSERT INTO COMMITTEE_MEMBERS VALUES(2, '2003-03-26', NULL, 'Member')
INSERT INTO COMMITTEE_MEMBERS VALUES(3, '2003-03-26', NULL, 'Secretary')
INSERT INTO COMMITTEE_MEMBERS VALUES(4, '2003-03-26', NULL, 'Treasurer')
INSERT INTO COMMITTEE_MEMBERS VALUES(5, '2003-03-26', NULL, 'Manager')

-- Task 4
-- Create a check constraint in Matches table to check
-- MatchNo must be greater or equal than 1.
-- TeamNo must be 1 or 2.
-- Display information about Matches table and try to insert value to implementing the constraint.
ALTER TABLE MATCHES
    ADD CONSTRAINT CHK_MATCHNO CHECK (MATCHNO >= 1)
    ADD CONSTRAINT CHK_TEAMNO CHECK (TEAMNO IN (1, 2))
GO
sp_help MATCHES
INSERT INTO MATCHES VALUES(1, 1, 1, 1, 0)

-- Task 5
-- Create a check constraint in Players table to check
-- PlayerNo must be greater or equal than 1.
-- Entries for Sex column. The valid values for Sex are ‘M’, ‘F’
-- Display information about Players table and try to insert value to implementing the constraint
ALTER TABLE PLAYERS
    ADD CONSTRAINT CHK_PLAYERNO  CHECK (PLAYERNO >= 1)
    ADD CONSTRAINT CHK_SEX CHECK (SEX IN ('M', 'F'))
GO
sp_help PLAYERS
INSERT INTO PLAYERS VALUES(1, 'Horas Marolop Amsal', 'HMA', '2003-03-26', 'M', 2010, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1')
INSERT INTO PLAYERS VALUES(2, 'Theofil Nainggolan', 'TN', '2003-03-26', 'F', 2010, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1')

-- Task -6
-- Although in Players table was there PHONENO column, Add Column PhoneNumber in
-- Players table. Then, create a check constraint in this table to check phone number format. The
-- format for this column is 082-xxxxxxxxx, x is digit from 1-9. The values of this column can
-- entry with null value.
ALTER TABLE PLAYERS
    ADD COLUMN PhoneNumber CHAR(13)
    ADD CONSTRAINT CHK_PHONENO CHECK (PhoneNumber LIKE '082-_________')
GO
sp_help PLAYERS
INSERT INTO PLAYERS VALUES(1, 'Horas Marolop Amsal', 'HMA', '2003-03-26', 'M', 2010, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1', '082-123456789')

-- Exercise 2: Creating unique constraint
-- Create a unique constraint for Committee_Members Table to make the combination value
-- of PlayerNo and Begin_Date column must be unique.
ALTER TABLE COMMITTEE_MEMBERS
    ADD CONSTRAINT UK_PLAYERNO_BEGIN_DATE UNIQUE (PLAYERNO, BEGIN_DATE)
GO

-- Exercise 3: Creating default constraint
-- Task – 1
-- Create a default value for Position column in Committee_Members table. The default value
-- is ‘Member’. Display information about Committee_Members table and try to insert value to
-- implementing the constraint.
ALTER TABLE COMMITTEE_MEMBERS
    ADD CONSTRAINT DF_POSITION DEFAULT 'Member' FOR POSITION
GO
sp_help COMMITTEE_MEMBERS
INSERT INTO COMMITTEE_MEMBERS VALUES(1, '2003-03-26', NULL, 'Chairman')

-- Task - 2
-- Create a default value for Sex column in Players table. The default value is ‘L’. Display
-- information about Players table and try to insert value to implementing the constraint.
ALTER TABLE PLAYERS
    ADD CONSTRAINT DF_SEX DEFAULT 'L' FOR SEX
GO
sp_help PLAYERS
INSERT INTO PLAYERS VALUES(1, 'Horas Marolop Amsal', 'HMA', '2003-03-26', 2010, 'Street 1', '1', '12345', 'Town 1', '1234567890', '1', '082-123456789')

-- Exercise 4: Creating Identity
-- Add one column for Committee_Members table and make it identity with seed 1 and increment 1.
ALTER TABLE COMMITTEE_MEMBERS
ADD CONSTRAINT PK_PLAYERNO PRIMARY KEY (PLAYERNO)

-- Exercise 5: Cascading Referential Integrity
-- Create Cascading Referential Integrity (foreign key with cascade) for:
-- • Penalties table.
-- If we update the Primary Key that related to Penalties table (PlayerNo as FK in Penalties
-- table and PlayerNo as PK in Players table), it automatically updates Penaltiestable. Try
-- to update and delete the table that related to Penalties.
ALTER TABLE PENALTIES
    ADD CONSTRAINT FK_PLAYERNO FOREIGN KEY (PLAYERNO) REFERENCES PLAYERS (PLAYERNO) ON UPDATE CASCADE ON DELETE CASCADE
GO
sp_help PENALTIES
UPDATE PLAYERS SET PLAYERNO = 2 WHERE PLAYERNO = 1
DELETE FROM PLAYERS WHERE PLAYERNO = 2

-- • Matches table
-- If we update or delete the Primary Key that related to Matches table (TeamNo as FK in
-- Matches table and TeamNo as PK in Teams table), it automatically updates or delete
-- related row in Matches table. Try to update and delete the table that related to Matches.
ALTER TABLE MATCHES
    ADD CONSTRAINT FK_TEAMNO FOREIGN KEY (TEAMNO) REFERENCES TEAMS (TEAMNO) ON UPDATE CASCADE ON DELETE CASCADE
GO
sp_help MATCHES
UPDATE TEAMS SET TEAMNO = 2 WHERE TEAMNO = 1
DELETE FROM TEAMS WHERE TEAMNO = 2