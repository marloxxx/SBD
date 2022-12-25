/*
 Nama	: Horas Marolop Amsal Siregar
 NIM		: 11321051
 Kelas	: 32TI2
 */
-- Task-1
-- List all players number and name who never had matches.
-- Cara 1 dengan subquery
SELECT PLAYERNO,
	NAME
FROM PLAYERS
WHERE PLAYERNO NOT IN (
		SELECT PLAYERNO
		FROM MATCHES
	) -- Cara 2 dengan join table
SELECT P.PLAYERNO,
	P.NAME
FROM PLAYERS P
	LEFT OUTER JOIN MATCHES M ON P.PLAYERNO = M.PLAYERNO
WHERE M.PLAYERNO IS NULL -- Task-2
	-- For each player who has ever incurred at least one penalty, get the player number, the
	-- name, and the total amount in penalties incurred.
SELECT P.PLAYERNO,
	P.NAME,
	SUM(PE.AMOUNT) AS TOTAL_AMOUNT
FROM PLAYERS P
	INNER JOIN PENALTIES PE ON P.PLAYERNO = PE.PLAYERNO
GROUP BY P.PLAYERNO,
	P.NAME -- Task-3
	-- What is the total amount of penalties incurred by players from Inglewood?
SELECT SUM(PE.AMOUNT) AS TOTAL_AMOUNT
FROM PLAYERS P
	INNER JOIN PENALTIES PE ON P.PLAYERNO = PE.PLAYERNO
WHERE P.TOWN = 'Inglewood' -- Task-4
	-- Get the numbers and names of the players for whom the total amount of penalties is
	-- higher than 100.
SELECT P.PLAYERNO,
	P.NAME
FROM PLAYERS P
	INNER JOIN PENALTIES PE ON P.PLAYERNO = PE.PLAYERNO
GROUP BY P.PLAYERNO,
	P.NAME
HAVING SUM(PE.AMOUNT) > 100 -- Task -5
	-- For each team that has played in the first division, give the team number, the number of
	-- matches, and the total number of sets won.
SELECT T.TEAMNO,
	M.MATCHNO,
	SUM(M.WON) AS TOTAL_SET
FROM TEAMS T
	INNER JOIN MATCHES M ON T.TEAMNO = M.TEAMNO
WHERE T.DIVISION = 'First'
GROUP BY T.TEAMNO,
	M.MATCHNO -- Task-6
	-- Get the name, initials, and number of penalties of each player who has incurred more
	-- than one penalty.
SELECT P.NAME,
	P.INITIALS,
	COUNT(PE.PAYMENTNO) AS TOTAL_PENALTY
FROM PLAYERS P
	INNER JOIN PENALTIES PE ON P.PLAYERNO = PE.PLAYERNO
GROUP BY P.NAME,
	P.INITIALS
HAVING COUNT(PE.PAYMENTNO) > 1
ORDER BY P.INITIALS -- Task-7
	-- Get the name, initials and number of penalties of each player who has incurred two or
	-- more penalties of more than $40.
SELECT P.NAME,
	P.INITIALS,
	COUNT(PE.PAYMENTNO) AS TOTAL_PENALTIES,
	AMOUNT
FROM PLAYERS P
	INNER JOIN PENALTIES PE ON P.PLAYERNO = PE.PLAYERNO
GROUP BY P.NAME,
	P.INITIALS,
	PE.AMOUNT
HAVING PE.AMOUNT > 40 -- Task-8
	-- Get the town, and many player live in a town
SELECT TOWN,
	COUNT(PLAYERNO) AS AVG
FROM PLAYERS
GROUP BY TOWN -- Task-9
	-- For each penalty, get the payment number, the amount and the difference between the
	-- -- amount and the average penalty amount.
SELECT PAYMENTNO,
	AMOUNT,
	ABS(
		AMOUNT - (
			SELECT AVG(AMOUNT)
			FROM PENALTIES
		)
	) AS Difference
FROM PENALTIES -- Task-10
	-- For each team captained by a player who lived in Startford, get the team number and the
	-- number of players who have won at least one match for that team
SELECT T.TEAMNO,
	COUNT(M.PLAYERNO) AS NUM_OF_PLAYERS
FROM TEAMS T
	INNER JOIN MATCHES M ON T.TEAMNO = M.TEAMNO
WHERE M.PLAYERNO IN (
		SELECT PLAYERNO
		FROM PLAYERS P
		WHERE P.TOWN = 'Stratford'
	)
GROUP BY T.TEAMNO,
	M.PLAYERNO
HAVING COUNT(M.PLAYERNO) > 0