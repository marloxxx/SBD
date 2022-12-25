/*
	Nama	: Horas Marolop Amsal Siregar
	NIM		: 11321051
	Kelas	: 32TI2
*/

-- Task 1
-- For each player who ever get penalties, get the number player and the difference between his
-- or her lowest and highest penalty amounts.
SELECT PLAYERNO, MAX(AMOUNT) - MIN(AMOUNT) AS 'Difference'
FROM PENALTIES
GROUP BY PLAYERNO

-- Task 2
-- Get the name and initials of each player whose total amount of penalties is the highest.
SELECT NAME, INITIALS
FROM PLAYERS
WHERE PLAYERNO IN (
    SELECT PLAYERNO
FROM PENALTIES
GROUP BY PLAYERNO
HAVING SUM(AMOUNT) = (
        SELECT MAX(SUM_AMT)
FROM (
            SELECT SUM(AMOUNT) AS SUM_AMT
    FROM PENALTIES
    GROUP BY PLAYERNO
        ) AS T
    )
)

-- Task 3
-- For each player, get the number, name and the difference between the year in which he/she
-- joined the club and the average year in which players who live in the same town joined the
-- club order by name.
SELECT PLAYERNO, NAME, ABS(JOINED - AVG_JOINED) AS Difference
FROM PLAYERS
    JOIN (
    SELECT TOWN, AVG(JOINED) AS AVG_JOINED
    FROM PLAYERS
    GROUP BY TOWN
) AS T
    ON PLAYERS.TOWN = T.TOWN
ORDER BY NAME

-- Task 4
-- Get the number, name and the date of birth of each player born in the same year as the
-- youngest player who played for the first team.
SELECT PLAYERNO, NAME, BIRTH_DATE
FROM PLAYERS
WHERE YEAR(BIRTH_DATE) = (
    SELECT TOP 1
    YEAR(BIRTH_DATE)
FROM PLAYERS
ORDER BY BIRTH_DATE DESC
)

-- Task 5
-- Create a SELECT statement that results in the following table:
SELECT COL1, COL2
FROM (
                            SELECT 'Number of players' AS COL1, COUNT(*) AS COL2
        FROM PLAYERS
    UNION ALL
        SELECT 'Number of teams' AS COL1, COUNT(*) AS COL2
        FROM TEAMS
    UNION ALL
        SELECT 'Number of matches' AS COL1, COUNT(*) AS COL2
        FROM MATCHES
) AS T