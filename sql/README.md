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
###### Inserting
```bash
INSERT INTO cd.facilities ( facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES(9, 'Spa', 20, 30, 100000, 800);
```

###### Inserting with Select
```bash
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
```

###### Update
```bash
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;
```

###### Update with calculation
```bash
UPDATE cd.facilities
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0),
guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0)
WHERE facilities.facid =1;
```

###### Delete all
```bash
DELETE FROM cd.bookings;
```

###### Delete condition
```bash
DELETE FROM cd.members
WHERE memid = 37;
```

###### Pattern Matching
```bash
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';
```

###### In clause
```bash
SELECT * FROM cd.facilities
WHERE facid IN (1,5);
```

###### Cases
```bash
SELECT name,
CASE WHEN (monthlymaintenance > 100) THEN 'expensive'
ELSE 'cheap'
END AS cost
FROM cd.facilities;
```

###### Filtering Date
```bash
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';
```

###### Basic Join
```bash
SELECT b.starttime
FROM cd.bookings b, cd.members m
WHERE m.firstname = 'David'
AND m.surname = 'Farrell'
AND b.memid = m.memid;
```

###### Join with Where
```bash
SELECT b.starttime AS start, f.name AS name
FROM cd.facilities f
INNER JOIN cd.bookings b ON f.facid = b.facid
WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2')
AND b.starttime >= '2012-09-21'
AND b.starttime < '2012-09-22'
ORDER BY b.starttime;
```

###### Left Join
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

###### Inner Join
```bash
SELECT DISTINCT
b.firstname AS firstname,
b.surname AS surname
FROM cd.members a
INNER JOIN cd.members b ON b.memid = a.recommendedby
ORDER BY surname,Mfirstname;
```

###### Subquery and Join
```bash
SELECT DISTINCT a.firstname || ' ' || a.surname AS member,
(SELECT b.firstname || ' ' || b.surname AS recommender
FROM cd.members b
WHERE b.memid = a.recommendedby
)
FROM cd.members a
ORDER BY member;
```

###### Group by order by
```bash
SELECT recommendedby, count(recommendedby)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;
```

###### Group by order by
```bash
SELECT facid, sum(slots)
FROM CD.BOOKINGS
GROUP BY facid
ORDER BY facid;
```

###### Group by with condition
```bash
SELECT facid, SUM(slots) AS Total_Slots
FROM CD.BOOKINGS
WHERE starttime >= '2012/09/01'
AND starttime < '2012/10/01'
GROUP BY facid
ORDER BY Total_Slots;
```

###### Group by multi col
```bash
SELECT facid, EXTRACT (MONTH FROM starttime) AS month, SUM(slots) AS Total_Slots
FROM cd.bookings
WHERE EXTRACT( YEAR FROM starttime) = 2012
GROUP BY bookings.facid, MONTH
ORDER BY facid;
```

###### Count distinct
```bash
SELECT COUNT(*)
FROM (SELECT DISTINCT memid FROM cd.bookings) AS count;
```

###### Group by multiple cols, join
```bash
SELECT a.surname, a.firstname, a.memid,
min(b.starttime) AS "first booking since september 2012"
FROM cd.bookings b
INNER JOIN cd.members a ON a.memid = b.memid
WHERE starttime >= '2012/09/01'
GROUP BY a.surname, a.firstname, a.memid
ORDER BY memid;
```

###### Window function
```bash
SELECT (SELECT COUNT(*) FROM cd.members) AS count, firstname, surname
FROM cd.members
ORDER BY joindate;
```

###### Window function
```bash
SELECT ROW_NUMBER() OVER(ORDER BY joindate), firstname, surname
FROM cd.members
ORDER BY joindate;
```

###### Window function, subquery, group by
```bash
SELECT facid, total
FROM (SELECT facid, SUM(slots) AS total,RANK() over (
ORDER BY SUM(slots) desc) rank
FROM cd.bookings
GROUP BY facid
) AS total
WHERE rank = 1;
```

###### Format string
```bash
SELECT CONCAT(surname, ', ', firstname) AS name
FROM cd.members;
```

###### WHERE + string function
```bash
SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]'
ORDER BY memid;
```

###### Group by, Substring
```bash
SELECT SUBSTR(a.surname, 1, 1) AS letter, COUNT(*) AS COUNT
FROM cd.members a
GROUP BY letter
ORDER BY letter;
```