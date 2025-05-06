\c psql_project;

--Modifying Data
--Q1) https://pgexercises.com/questions/updates/insert.html
INSERT INTO cd.facilities ( facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES(9, 'Spa', 20, 30, 100000, 800);

--Q2) https://pgexercises.com/questions/updates/insert3.html select in insert
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

--Q3) https://pgexercises.com/questions/updates/update.html update
UPDATE cd.facilities
    SET initialoutlay = 10000
    WHERE facid = 1;

--Q4) https://pgexercises.com/questions/updates/updatecalculated.html update with calculation
UPDATE cd.facilities
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0),
    guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0)
WHERE facilities.facid =1;

--Q5) https://pgexercises.com/questions/updates/delete.html delete all
DELETE FROM cd.bookings;

--Q6) https://pgexercises.com/questions/updates/deletewh.html delete condition
DELETE FROM cd.members
WHERE memid = 37;

--Basics
--Q7) https://pgexercises.com/questions/basic/where2.html
SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities
WHERE membercost > 0
  AND membercost < 0.02 * monthlymaintenance;

--Q8) https://pgexercises.com/questions/basic/where3.html
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';

--Q9) https://pgexercises.com/questions/basic/where4.html
SELECT * FROM cd.facilities
WHERE facid IN (1,5);

--Q10) https://pgexercises.com/questions/basic/date.html
SELECT name,
       CASE WHEN (monthlymaintenance > 100) THEN 'expensive'
            ELSE 'cheap'
       END AS cost
FROM cd.facilities;

--Q11) https://pgexercises.com/questions/basic/union.html
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';

--Join
--Q12) https://pgexercises.com/questions/joins/simplejoin.html
SELECT b.starttime
FROM cd.bookings b, cd.members m
WHERE m.firstname = 'David'
  AND m.surname = 'Farrell'
  AND b.memid = m.memid;

--Q13) https://pgexercises.com/questions/joins/simplejoin2.html
SELECT b.starttime AS start, f.name AS name
FROM cd.facilities f
    INNER JOIN cd.bookings b ON f.facid = b.facid
WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2')
  AND b.starttime >= '2012-09-21'
  AND b.starttime < '2012-09-22'
ORDER BY b.starttime;

--Q14) https://pgexercises.com/questions/joins/self2.html (three joins)
SELECT
    a.firstname AS memfname,
    a.surname AS memsname,
    b.firstname AS recfname,
    b.surname AS recsname
FROM cd.members a
    LEFT JOIN cd.members b ON b.memid = a.recommendedby
ORDER BY memsname, memfname;

--Q15) https://pgexercises.com/questions/joins/self.html three joins
SELECT DISTINCT
    b.firstname AS firstname,
    b.surname AS surname
FROM cd.members a
    INNER JOIN cd.members b ON b.memid = a.recommendedby
ORDER BY surname,Mfirstname;

--Q16) https://pgexercises.com/questions/joins/sub.html (subquery and join)
SELECT DISTINCT a.firstname || ' ' || a.surname AS member,
    (SELECT b.firstname || ' ' || b.surname AS recommender
    FROM cd.members b
    WHERE b.memid = a.recommendedby
    )
FROM cd.members a
ORDER BY member;

--Aggregation
--Q17) https://pgexercises.com/questions/aggregates/count3.html Group by order by
SELECT recommendedby, count(recommendedby)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

--Q18) https://pgexercises.com/questions/aggregates/fachours.html group by order by
SELECT facid, sum(slots)
FROM CD.BOOKINGS
GROUP BY facid
ORDER BY facid;

--Q19) https://pgexercises.com/questions/aggregates/fachoursbymonth.html group by with condition
SELECT facid, SUM(slots) AS Total_Slots
FROM CD.BOOKINGS
WHERE starttime >= '2012/09/01'
  AND starttime < '2012/10/01'
GROUP BY facid
ORDER BY Total_Slots;

--Q20) https://pgexercises.com/questions/aggregates/fachoursbymonth2.html group by multi col
SELECT facid, EXTRACT (MONTH FROM starttime) AS month, SUM(slots) AS Total_Slots
FROM cd.bookings
WHERE EXTRACT( YEAR FROM starttime) = 2012
GROUP BY bookings.facid, MONTH
ORDER BY facid;

--Q21) https://pgexercises.com/questions/aggregates/members1.html count distinct
SELECT COUNT(*)
FROM (SELECT DISTINCT memid FROM cd.bookings) AS count;

--Q22) https://pgexercises.com/questions/aggregates/nbooking.html group by multiple cols, join
SELECT
    a.surname,
    a.firstname,
    a.memid,
    min(b.starttime) AS "first booking since september 2012"
FROM
    cd.bookings b
        INNER JOIN cd.members a ON a.memid = b.memid
WHERE
    starttime >= '2012/09/01'
GROUP BY
    a.surname,
    a.firstname,
    a.memid
ORDER BY
    memid;

--Q23) https://pgexercises.com/questions/aggregates/countmembers.html window function
SELECT (SELECT COUNT(*) FROM cd.members) AS count, firstname, surname
FROM cd.members
ORDER BY joindate;

--Q24) https://pgexercises.com/questions/aggregates/nummembers.html window function
SELECT ROW_NUMBER() OVER(ORDER BY joindate), firstname, surname
FROM cd.members
ORDER BY joindate;

--Q25) https://pgexercises.com/questions/aggregates/fachours4.html window function, subquery, group by
SELECT facid, total
FROM (SELECT facid, SUM(slots) AS total,RANK() over (
     ORDER BY SUM(slots) desc) rank
     FROM cd.bookings
     GROUP BY facid
     ) AS total
WHERE rank = 1;

--String
--Q26) https://pgexercises.com/questions/string/concat.html format string
SELECT CONCAT(surname, ', ', firstname) AS name
FROM cd.members;

--Q27) https://pgexercises.com/questions/string/reg.html WHERE + string function
SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]'
ORDER BY memid;

--Q28) https://pgexercises.com/questions/string/substr.html group by, substr
SELECT SUBSTR(a.surname, 1, 1) AS letter, COUNT(*) AS COUNT
FROM cd.members a
GROUP BY letter
ORDER BY letter;