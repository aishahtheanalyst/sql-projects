# world life expectancy (exploratory data analysis)
SELECT *
FROM world_life_expectancy;

# calculate the overall average life expectancy
SELECT AVG(`Life expectancy`) AS Average_Life_Expectancy
FROM world_life_expectancy;

# calculate the average life expectancy for each year
SELECT Year, ROUND(AVG(`Life expectancy`),1) AS Average_Life_Expectancy
FROM world_life_expectancy
GROUP BY Year
ORDER BY Year;

# calculate the average life expectancy for each country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Average_Life_Expectancy
FROM world_life_expectancy
GROUP BY Country
ORDER BY Country;

# calculate health expenditure percentage for each country in 2020 (possibly use join covid-19 data to see correlation)
SELECT Country, Year, GDP, `percentage expenditure`,
       ROUND((`percentage expenditure` / GDP) * 100, 1) AS health_expenditure_percentage
FROM world_life_expectancy
WHERE Year = 2020
AND `percentage expenditure` <> 0 ;

# calculate the ratio of infant deaths to under-five deaths for each country in 2020
SELECT Country, ROUND((SUM(`infant deaths`) / SUM(`under-five deaths`)) * 100, 1) AS Infant_To_Under_Five_Ratio
FROM world_life_expectancy
WHERE Year = 2020
AND `infant deaths` <> 0
GROUP BY Country;

# calculate the increase in life expectancy over 15 years for each country
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC;

# calculate the average life expectancy for each year, excluding zero values
SELECT Year, 
ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year;

# calculate the average life expectancy and GDP for each country, excluding zero values
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy, 
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0
AND GDP > 0
ORDER BY GDP DESC;

# analyse counts and averages based on GDP thresholds
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Count_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Count_Life_Expectancy
FROM world_life_expectancy;

# calculate average life expectancy by status
SELECT Status, 
ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy
FROM world_life_expectancy
GROUP BY Status;

# analyse counts and averages based on status
SELECT Status, 
COUNT(DISTINCT Country) AS Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy
FROM world_life_expectancy
GROUP BY Status;

# analyse average life expectancy and BMI for each country
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy, 
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0	
AND BMI > 0
ORDER BY BMI ASC;

# calculate rolling total of adult mortality for each country over the years
SELECT Country, 
Year, 
`Life expectancy`, 
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%';


