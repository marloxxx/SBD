/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

-- Exercise 1: Selecting Rows

-- Task 1
-- List all data stored in the table PLAYERS. (14 rows)
SELECT * FROM PLAYERS;

-- Task -2
-- List all players who do not live in Stratford and not in Douglas. (6 rows)
SELECT * FROM PLAYERS WHERE town NOT IN('Stratford', 'Douglas');

-- Task -3
-- Get the number of each players who has no league number. (4 rows)
SELECT PLAYERNO FROM PLAYERS WHERE LEAGUENO LIKE '';

-- Task -4
-- Find the player numbers of those who joined the club between 1970 and 1980. (7 rows)
SELECT PLAYERNO FROM PLAYERS WHERE JOINED BETWEEN 1970 AND 1980;

-- Task -5
-- Find the number and date of birth of each player born between 1962 and 1964. (9 rows)
SELECT PLAYERNO, BIRTH_DATE FROM PLAYERS WHERE BIRTH_DATE BETWEEN '1962-01-01' AND '1964-12-31';

-- Task -6
-- Find the number and name of each player whose name is at least six characters long. (10 rows)
SELECT PLAYERNO, NAME FROM PLAYERS WHERE LEN(NAME) >= 6;

-- Task-7
-- Find the number and name of each player whose name contains the string letters “is”. (2 rows)
SELECT PLAYERNO, NAME FROM PLAYERS WHERE NAME LIKE '%is%';

-- Task-8
-- Get the name and number of each player whose name has the lower-case letter e as the penultimate letter. (8 rows)
SELECT PLAYERNO, NAME FROM PLAYERS WHERE NAME LIKE '%e_';

-- Task-9
-- Get the payment number of each penalty that is not between $50 and $100. (3 rows)
SELECT PAYMENTNO FROM PENALTIES WHERE AMOUNT NOT BETWEEN 50 AND 100;

-- Task-10
-- Get the number and name of the players who joined the club after the age of 16 and before reaching their 40s. (9 rows)
SELECT PLAYERNO, NAME FROM PLAYERS WHERE JOINED > YEAR(BIRTH_DATE) + 16 AND JOINED < YEAR(BIRTH_DATE) + 40;

-- Exercise 2: Limiting/Grouping Result Set and Using Aggregate Function

-- Task–1
-- Get the number of penalties and the highest penalty amount.
SELECT COUNT(PAYMENTNO) AS 'Number of Penalties', MAX(AMOUNT) 'Highest Penalty' FROM PENALTIES;

-- Task–2
-- Get the number of league numbers of players resident in Inglewood.
SELECT COUNT(LEAGUENO) AS 'Number of League Numbers' FROM PLAYERS WHERE TOWN = 'Inglewood';

-- Task–3
-- Get the lowest number of sets won by which a match has been won
SELECT MIN(WON) FROM MATCHES WHERE WON > LOST;

-- Task–4
-- For each player who has incurred at least one penalty, give the player number, average penalty
-- amount, and the number of penalties order by player number.
SELECT PLAYERNO, AVG(AMOUNT) AS 'Average Penalty Amount', COUNT(PAYMENTNO) AS 'Number of Penalties' FROM PENALTIES GROUP BY PLAYERNO ORDER BY PLAYERNO;

-- Task-5
-- For each combination of won-lost sets, get the number of matches won.
SELECT WON, LOST, COUNT(*) AS 'Number of Matches Won' FROM MATCHES GROUP BY WON, LOST;

-- Task-6
-- For each combination of year-month, get the number of committee members who started in that
-- year and that month
SELECT YEAR(BEGIN_DATE) AS 'Year', MONTH(BEGIN_DATE) AS 'Month', COUNT(*) AS 'Number of Committee Members' FROM COMMITTEE_MEMBERS GROUP BY YEAR(BEGIN_DATE), MONTH(BEGIN_DATE);

-- Task-7
-- Get the player number and total amounts who has incurred more than $150 in penalties and
-- group them by player number.
SELECT PLAYERNO, SUM(AMOUNT) AS 'Total Amount' FROM PENALTIES GROUP BY PLAYERNO HAVING SUM(AMOUNT) > 150;

-- Task-8
-- Get the team number for which most players have played, and give the number of players who have played for this team.
SELECT TOP 1 TEAMNO, COUNT(*) AS 'Number of Players' FROM TEAMS GROUP BY TEAMNO ORDER BY TEAMNO DESC;

-- Task-9
-- Get player number who have incurred as many penalties as player 6.
SELECT PLAYERNO FROM PENALTIES WHERE PLAYERNO != 6 GROUP BY PLAYERNO HAVING COUNT(PAYMENTNO) = (SELECT COUNT(PAYMENTNO) FROM PENALTIES WHERE PLAYERNO = 6);

-- Task-10
-- Get the names of the players for whom the length of their name is greater than the average
-- length.
SELECT NAME FROM PLAYERS WHERE LEN(NAME) > (SELECT AVG(LEN(NAME)) FROM PLAYERS);

-- Task-11: using INFORMATION_SCHEMA
-- List all table that already created in your TennisDB database.
SELECT * FROM INFORMATION_SCHEMA.TABLES;
-- List all information about metadata of Players table (column name, ordinal position of column, is nullable or not, data type and length of column).
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PLAYERS';
-- List all check constraints that already created in TennisDB database.
SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS;
-- List all constraints that already created in Players table.
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'PLAYERS';
-- List all tables that have composite primary key (two columns as primary key).
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME IN (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' GROUP BY TABLE_NAME HAVING COUNT(*) > 1);