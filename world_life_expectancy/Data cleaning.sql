# world life expectancy project (data cleaning)

SELECT *
FROM world_life_expectancy;

# find duplicate records
SELECT 
    Country,
    Year,
    CONCAT(Country, Year),
    COUNT(CONCAT(Country, Year))
FROM 
	world_life_expectancy
GROUP BY 
Country , 
Year , 
	CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

# identify duplicates using a temp table Row_Num
SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) as Row_Table
WHERE Row_Num > 1;

# delete duplicate records
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) as Row_Table
WHERE Row_Num > 1);

# display records where Status is empty
SELECT *
FROM world_life_expectancy
WHERE Status = '';

# display unique Status values excluding empty strings
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> '';

SELECT DISTINCT (Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

# update Status for records where it is empty and 'Developing'
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developing';

# display records for the UK
SELECT *
FROM world_life_expectancy
WHERE Country = 'United Kingdom';

# update Status for records where it is empty and 'Developed'
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developed';

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';


SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

# update Life Expectancy for records where it is empty by taking the average of the previous and next year
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = '' ;




