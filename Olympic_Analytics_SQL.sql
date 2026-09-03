CREATE DATABASE Olympic_Analytics;
SHOW DATABASES;
USE Olympic_Analytics;
SHOW TABLES;
SELECT COUNT(*) AS athlete_records
FROM athlete_events;
SELECT COUNT(*) AS region_records
FROM noc_regions;
SHOW TABLES;
DROP TABLE IF EXISTS athlete_events;
DROP TABLE IF EXISTS athlete_events_cleaned;
SHOW TABLES;
CREATE TABLE athlete_events (
    ID INT,
    Name VARCHAR(150),
    Sex CHAR(1),
    Age INT NULL,
    Height INT NULL,
    Weight INT NULL,
    Team VARCHAR(150),
    NOC VARCHAR(5),
    Games VARCHAR(30),
    Year INT,
    Season VARCHAR(10),
    City VARCHAR(50),
    Sport VARCHAR(100),
    Event VARCHAR(255),
    Medal VARCHAR(20)
);
SHOW TABLES;
CREATE TABLE noc_regions (
    NOC VARCHAR(5),
    Region VARCHAR(100),
    Notes VARCHAR(255)
);
SHOW TABLES;
SELECT COUNT(*) FROM athlete_events;
SELECT COUNT(*) FROM noc_regions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/athlete_events_cleaned.csv'
INTO TABLE athlete_events
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
ID,
Name,
Sex,
@Age,
@Height,
@Weight,
Team,
NOC,
Games,
Year,
Season,
City,
Sport,
Event,
Medal
)
SET
Age = NULLIF(@Age,''),
Height = NULLIF(@Height,''),
Weight = NULLIF(@Weight,'');
SELECT COUNT(*) AS athlete_records
FROM athlete_events;
CREATE TABLE noc_regions (
    NOC VARCHAR(5),
    Region VARCHAR(100),
    Notes VARCHAR(255)
);
SELECT COUNT(*) AS region_records
FROM noc_regions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/noc_regions_cleaned.csv'
INTO TABLE noc_regions
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(NOC, Region, Notes);
SELECT COUNT(*) AS region_records
FROM noc_regions;
SELECT *
FROM athlete_events
LIMIT 10;
SELECT COUNT(DISTINCT ID) AS total_athletes
FROM athlete_events;
SELECT COUNT(DISTINCT Games) AS total_olympic_games
FROM athlete_events;
SELECT COUNT(DISTINCT Sport) AS total_sports
FROM athlete_events;
SELECT COUNT(DISTINCT NOC) AS total_countries
FROM athlete_events;
SELECT COUNT(Medal) AS total_medals
FROM athlete_events;
SELECT 
    Medal,
    COUNT(*) AS medal_count
FROM athlete_events
WHERE Medal IS NOT NULL
GROUP BY Medal
ORDER BY medal_count DESC;
SELECT 
    n.Region AS Country,
    COUNT(a.Medal) AS Total_Medals
FROM athlete_events a
JOIN noc_regions n
ON a.NOC = n.NOC
WHERE a.Medal IS NOT NULL
GROUP BY n.Region
ORDER BY Total_Medals DESC
LIMIT 10;
SELECT
    n.Region AS Country,
    a.Medal,
    COUNT(*) AS Medal_Count
FROM athlete_events a
JOIN noc_regions n
ON a.NOC = n.NOC
WHERE a.Medal IS NOT NULL
GROUP BY n.Region, a.Medal
ORDER BY Country, Medal_Count DESC;
SELECT
    Sex,
    COUNT(DISTINCT ID) AS Athletes
FROM athlete_events
GROUP BY Sex;
SELECT
    Name,
    Team,
    COUNT(Medal) AS Total_Medals
FROM athlete_events
WHERE Medal IS NOT NULL
GROUP BY Name, Team
ORDER BY Total_Medals DESC
LIMIT 10;
SELECT
    Name,
    Team,
    COUNT(Medal) AS Gold_Medals
FROM athlete_events
WHERE Medal = 'Gold'
GROUP BY Name, Team
ORDER BY Gold_Medals DESC
LIMIT 10;
SELECT
    ROUND(AVG(Age),2) AS Average_Age
FROM athlete_events;
SELECT
    CASE
        WHEN Age < 20 THEN 'Under 20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age >= 40 THEN '40+'
    END AS Age_Group,
    COUNT(*) AS Athletes
FROM athlete_events
WHERE Age IS NOT NULL
GROUP BY Age_Group
ORDER BY Athletes DESC;
SELECT
    Name,
    Age,
    Sport,
    Medal
FROM athlete_events
WHERE Medal IS NOT NULL
AND Age IS NOT NULL
ORDER BY Age ASC
LIMIT 10;
SELECT
    Sport,
    COUNT(Medal) AS Total_Medals
FROM athlete_events
WHERE Medal IS NOT NULL
GROUP BY Sport
ORDER BY Total_Medals DESC
LIMIT 10;
SELECT
    Sport,
    COUNT(DISTINCT ID) AS Total_Athletes
FROM athlete_events
GROUP BY Sport
ORDER BY Total_Athletes DESC
LIMIT 10;
SELECT
    n.Region AS Country,
    a.Sport,
    COUNT(a.Medal) AS Total_Medals
FROM athlete_events a
JOIN noc_regions n
ON a.NOC = n.NOC
WHERE a.Medal IS NOT NULL
GROUP BY n.Region, a.Sport
ORDER BY Total_Medals DESC
LIMIT 20;
SELECT
    Event,
    COUNT(*) AS Participants
FROM athlete_events
GROUP BY Event
ORDER BY Participants DESC
LIMIT 10;
SELECT
    Year,
    COUNT(DISTINCT ID) AS Total_Athletes
FROM athlete_events
GROUP BY Year
ORDER BY Year;
SELECT
    Year,
    COUNT(Medal) AS Total_Medals
FROM athlete_events
WHERE Medal IS NOT NULL
GROUP BY Year
ORDER BY Year;
SELECT
    Year,
    Sex,
    COUNT(DISTINCT ID) AS Athletes
FROM athlete_events
GROUP BY Year, Sex
ORDER BY Year;
SELECT
    n.Region,
    COUNT(a.Medal) AS Total_Medals,
    RANK() OVER (ORDER BY COUNT(a.Medal) DESC) AS Country_Rank
FROM athlete_events a
JOIN noc_regions n
ON a.NOC = n.NOC
WHERE a.Medal IS NOT NULL
GROUP BY n.Region;
CREATE VIEW Country_Medal_Count AS
SELECT
    n.Region,
    COUNT(a.Medal) AS Total_Medals
FROM athlete_events a
JOIN noc_regions n
ON a.NOC = n.NOC
WHERE a.Medal IS NOT NULL
GROUP BY n.Region;
SELECT * FROM Country_Medal_Count;