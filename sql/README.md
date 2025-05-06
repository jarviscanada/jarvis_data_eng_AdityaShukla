# Introduction

---
The RDBMS_SQL project is a Minimum Viable Product (MVP), designed to store information about a country club in an SQL database. 
The database stores information regarding the members, facilities, and booking history. 
This project allows users to perform various CRUD actions as follows, the queries for which are stored in the queries.sql file.
- inserting additional data, 
- removing a member, 
- updating the monthly maintenance cost of a facility,
- analyzing the bookings within a month,
- identifying which facilities are used frequently.

Additionally, Git has been used for version control.

# Tables

---
## Table Structure of `cd.members`
| Attribute      | Data Type     | Constraint                                              |
|----------------|---------------|---------------------------------------------------------|
| memid          | INTEGER       | Primary Key                                             |
| surname        | VARCHAR(200)  | NOT NULL                                                |
| firstname      | VARCHAR(200)  | NOT NULL                                                |
| addess         | VARCHAR(300)  | NOT NULL                                                |
| zipcode        | INTEGER       | NOT NULL                                                |
| telephone      | VARCHAR(20)   | NOT NULL                                                |
| recommendedby  | INTEGER       | FOREIGN KEY; REFERENCES PRIMARY KEY memid in cd.members |
| joindate       | TIMESTAMP     | NOT NULL                                                |

## Table Structure of `cd.bookings`
| Attribute | Data Type | Constraint                                                 |
|----------|-----------|------------------------------------------------------------|
| bookid   | INTEGER   | Primary Key                                                |
| facid    | INTEGER   | FOREIGN KEY; REFERENCES PRIMARY KEY facid in cd.facilities |
| memid    | INTEGER   | FOREIGN KEY; REFERENCES PRIMARY KEY memid in cd.members    |
| starttime| TIMESTAMP | NOT NULL                                                   |
| slots    | INTEGER   | NOT NULL                                                   |

## Table Structure of `cd.facilities`
| Attribute           | Data Type    | Constraint  |
|---------------------|--------------|-------------| 
| facid	              | INTEGR       | PRIMARY KEY |
| name	               | VARCHAR(100) | NOT NULL    |
| membercost          | NUMERIC      | NOT NULL    |  
| guestcost	          | NUMERIC      | NOT NULL    |
| initialoutlay	      | NUMERIC	     | NOT NULL    |  
| monthlymaintenance  | 	NUMERIC     | NOT NULL    |

# SQL QUERIES

---
## Table Setup (DDL)

---
### Creating `cd.members` table
``` bash
CREATE TABLE IF NOT EXISTS cd.members (
	memid INTEGER NOT NULL,
	surname VARCHAR(200) NOT NULL,
	firstname VARCHAR(200) NOT NULL,
	address VARCHAR(300) NOT NULL,
	zipcode INTEGER NOT NULL,
	telephone VARCHAR(20) NOT NULL,
	recommendedby INTEGER,
	joindate TIMESTAMP NOT NULL,
	CONSTRAINT members_pk PRIMARY KEY (memid),
    CONSTRAINT members_recommendedby_fk FOREIGN KEY (recommendedby)
		 REFERENCES cd.members(memid) ON DELETE SET NULL
);
```
### Creating `cd.bookings` table
``` bash
CREATE TABLE IF NOT EXISTS cd.bookings (
	bookid INTEGER NOT NULL,
	facid INTEGER NOT NULL,
	memid INTEGER NOT NULL,
	starttime TIMESTAMP NOT NULL,
	slots INTEGER NOT NULL,
	CONSTRAINT bookings_pk PRIMARY KEY (bookid),
    CONSTRAINT bookings_facid_fk FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
    CONSTRAINT bookings_memid_fk FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
```
### Creating `cd.facilities` table
``` bash
CREATE TABLE IF NOT EXISTS cd.facilities (
	facid INTEGER NOT NULL,
	name VARCHAR(100) NOT NULL,
	membercost NUMERIC NOT NULL,
	guestcost NUMERIC NOT NULL,
	initialoutlay NUMERIC NOT NULL,
	monthlymaintenance NUMERIC NOT NULL,
	CONSTRAINT facilities_pk PRIMARY KEY (facid)
);
```
## Questions

---
###### Question 1: https://pgexercises.com/questions/updates/insert.html
```bash
INSERT INTO cd.facilities ( facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES(9, 'Spa', 20, 30, 100000, 800);
```

###### Question 2: https://pgexercises.com/questions/updates/insert3.html select in insert
```bash
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
```

###### Question 3: https://pgexercises.com/questions/updates/update.html update
```bash
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;
```

###### Question 4: https://pgexercises.com/questions/updates/updatecalculated.html update with calculation
```bash
UPDATE cd.facilities
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0),
guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0)
WHERE facilities.facid =1;
```

###### Question 5: https://pgexercises.com/questions/updates/delete.html delete all
```bash
DELETE FROM cd.bookings;
```

###### Question 6:  https://pgexercises.com/questions/updates/deletewh.html delete condition
```bash
DELETE FROM cd.members
WHERE memid = 37;
```

###### Question 7: https://pgexercises.com/questions/basic/where2.html
```bash
SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities
WHERE membercost > 0
AND membercost < 0.02 * monthlymaintenance;
```

###### Question 8: https://pgexercises.com/questions/basic/where3.html
```bash
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';
```

###### Question 9: https://pgexercises.com/questions/basic/where4.html
```bash
SELECT * FROM cd.facilities
WHERE facid IN (1,5);
```

###### Question 10: https://pgexercises.com/questions/basic/date.html
```bash
SELECT name,
CASE WHEN (monthlymaintenance > 100) THEN 'expensive'
ELSE 'cheap'
END AS cost
FROM cd.facilities;
```

###### Question 11: https://pgexercises.com/questions/basic/union.html
```bash
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';
```

###### Question 12: https://pgexercises.com/questions/joins/simplejoin.html
```bash
SELECT b.starttime
FROM cd.bookings b, cd.members m
WHERE m.firstname = 'David'
AND m.surname = 'Farrell'
AND b.memid = m.memid;
```

###### Question 13: https://pgexercises.com/questions/joins/simplejoin2.html
```bash
SELECT b.starttime AS start, f.name AS name
FROM cd.facilities f
INNER JOIN cd.bookings b ON f.facid = b.facid
WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2')
AND b.starttime >= '2012-09-21'
AND b.starttime < '2012-09-22'
ORDER BY b.starttime;
```

###### Question 14: https://pgexercises.com/questions/joins/self2.html (three joins)
```bash
SELECT
a.firstname AS memfname,
a.surname AS memsname,
b.firstname AS recfname,
b.surname AS recsname
FROM cd.members a
LEFT JOIN cd.members b ON b.memid = a.recommendedby
ORDER BY memsname, memfname;
```

###### Question 15: https://pgexercises.com/questions/joins/self.html three joins
```bash
SELECT DISTINCT
b.firstname AS firstname,
b.surname AS surname
FROM cd.members a
INNER JOIN cd.members b ON b.memid = a.recommendedby
ORDER BY surname,Mfirstname;
```

###### Question 16: https://pgexercises.com/questions/joins/sub.html (subquery and join)
```bash
SELECT DISTINCT a.firstname || ' ' || a.surname AS member,
(SELECT b.firstname || ' ' || b.surname AS recommender
FROM cd.members b
WHERE b.memid = a.recommendedby
)
FROM cd.members a
ORDER BY member;
```

###### Question 17: https://pgexercises.com/questions/aggregates/count3.html Group by order by
```bash
SELECT recommendedby, count(recommendedby)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;
```

###### Question 18: https://pgexercises.com/questions/aggregates/fachours.html group by order by
```bash
SELECT facid, sum(slots)
FROM CD.BOOKINGS
GROUP BY facid
ORDER BY facid;
```

###### Question 19: https://pgexercises.com/questions/aggregates/fachoursbymonth.html group by with condition
```bash
SELECT facid, SUM(slots) AS Total_Slots
FROM CD.BOOKINGS
WHERE starttime >= '2012/09/01'
AND starttime < '2012/10/01'
GROUP BY facid
ORDER BY Total_Slots;
```

###### Question 20: https://pgexercises.com/questions/aggregates/fachoursbymonth2.html group by multi col
```bash
SELECT facid, EXTRACT (MONTH FROM starttime) AS month, SUM(slots) AS Total_Slots
FROM cd.bookings
WHERE EXTRACT( YEAR FROM starttime) = 2012
GROUP BY bookings.facid, MONTH
ORDER BY facid;
```

###### Question 21: https://pgexercises.com/questions/aggregates/members1.html count distinct
```bash
SELECT COUNT(*)
FROM (SELECT DISTINCT memid FROM cd.bookings) AS count;
```

###### Question 22: https://pgexercises.com/questions/aggregates/nbooking.html group by multiple cols, join
```bash
SELECT a.surname, a.firstname, a.memid,
min(b.starttime) AS "first booking since september 2012"
FROM cd.bookings b
INNER JOIN cd.members a ON a.memid = b.memid
WHERE starttime >= '2012/09/01'
GROUP BY a.surname, a.firstname, a.memid
ORDER BY memid;
```

###### Question 23: https://pgexercises.com/questions/aggregates/countmembers.html window function
```bash
SELECT (SELECT COUNT(*) FROM cd.members) AS count, firstname, surname
FROM cd.members
ORDER BY joindate;
```

###### Question 24: https://pgexercises.com/questions/aggregates/nummembers.html window function
```bash
SELECT ROW_NUMBER() OVER(ORDER BY joindate), firstname, surname
FROM cd.members
ORDER BY joindate;
```

###### Question 25: https://pgexercises.com/questions/aggregates/fachours4.html window function, subquery, group by
```bash
SELECT facid, total
FROM (SELECT facid, SUM(slots) AS total,RANK() over (
ORDER BY SUM(slots) desc) rank
FROM cd.bookings
GROUP BY facid
) AS total
WHERE rank = 1;
```

###### Question 26: https://pgexercises.com/questions/string/concat.html format string
```bash
SELECT CONCAT(surname, ', ', firstname) AS name
FROM cd.members;
```

###### Question 27: https://pgexercises.com/questions/string/reg.html WHERE + string function
```bash
SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]'
ORDER BY memid;
```

###### Question 28: https://pgexercises.com/questions/string/substr.html group by, substr
```bash
SELECT SUBSTR(a.surname, 1, 1) AS letter, COUNT(*) AS COUNT
FROM cd.members a
GROUP BY letter
ORDER BY letter;
```