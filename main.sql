-- Creating forestation table

CREATE VIEW forestation AS (SELECT f.country_name,f.year,f.forest_area_sqkm,l.total_area_sq_mi,((SUM(forest_area_sqkm)/SUM(to tal_area_sq_mi)*2.59)*100) AS percentage_forest,r.region,r.income_group
FROM forest_area f
JOIN land_area l
ON f.country_code = l.country_code AND f.year = l.year JOIN regions r
ON r.country_code = l.country_code
GROUP BY f.country_name,f.year,f.forest_area_sqkm,l.total_area_sq_mi,r.region,r.income_group)
GLOBAL SITUATION

-- total forest area (in sq km) of the world in 1990

SELECT SUM(forest_area_sqkm) as total_sqkm FROM forestation
WHERE year ='1990' AND country_name ='World'

-- total forest area (in sq km) of the world in 2016

SELECT SUM(forest_area_sqkm) as total_sqkm FROM forestation
WHERE year ='2016' AND country_name ='World'

-- change (in sq km) in the forest area of the world from 1990 to 2016

SELECT((SELECT SUM(forest_area_sqkm) as total_sqkm
FROM forestation
WHERE year ='1990' AND country_name ='World')-(SELECT SUM(forest_area_sqkm) as total_sqkm
FROM forestation
WHERE year ='2016' AND country_name ='World'))AS change
FROM forestation
LIMIT 1

-- the percent change in forest area of the world between 1990 and 2016

SELECT(((SELECT SUM(forest_area_sqkm) as total_sqkm
FROM forestation
WHERE year ='1990' AND country_name ='World')-(SELECT SUM(forest_area_sqkm) as total_sqkm
FROM forestation
WHERE year ='2016' AND country_name ='World'))/ (SELECT(SELECT SUM(forest_area_sqkm) total_forest_area
FROM forestation LIMIT 1)
FROM forestation
WHERE year ='1990' AND country_name ='World')*100)AS percentage_change

-- country's total area in 2016 is it closest to change

SELECT country_name, SUM(total_area_sq_mi*2.59) total_land_area FROM forestation
WHERE YEAR = '2016' AND total_area_sq_mi != '0'
GROUP BY country_name,total_area_sq_mi
ORDER BY total_land_area DESC

-- REGIONAL OUTLOOK
-- percent forest of the entire world in 2016

SELECT country_name, ROUND(((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100)::Numeric,2)percent_fore st_area
FROM forestation
WHERE YEAR = ‘2016’ AND country_name ='World'
GROUP BY country_name

-- Highest and lowest forest percent in 2016

SELECT region, ROUND(((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100)::Numeric,2)percent_fore st_area
FROM forestation
WHERE YEAR = '2016'
GROUP BY region
ORDER BY percent_forest_area DESC

-- percent forest of the entire world in 1990

SELECT country_name, ROUND(((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100)::Numeric,2)percent_fore st_area
FROM forestation
    WHERE YEAR = '1990' AND country_name ='World' GROUP BY country_name
-- Highest and lowest forest percent in 1990

SELECT region, ROUND(((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100)::Numeric,2)percent_fore st_area
FROM forestation
WHERE YEAR = '1990'
GROUP BY region
ORDER BY percent_forest_area DESC

-- COUNTRY LEVEL DETAIL A.SUCCESS STORIES
-- Success stories forest area change ascending

WITH T1 AS (SELECT country_name,region,SUM(forest_area_sqkm)AS forest_area1 FROM forestation
WHERE year ='1990'
GROUP BY country_name,region,forest_area_sqkm),
T2 AS (SELECT country_name,region,SUM(forest_area_sqkm) AS forest_area2
FROM forestation
WHERE year='2016'
GROUP BY country_name,region,forest_area_sqkm)
SELECT ft1.country_name,ft1.region,(ft1.forest_area1 - ft2.forest_area2) as forest_difference FROM T1 ft1
JOIN T2 ft2
ON ft1.country_name = ft2.country_name
WHERE ft1.forest_area1 IS NOT NULL AND ft2.forest_area2 IS NOT NULL AND ft1.country_name !='World'
GROUP BY ft1.country_name,ft1.region,ft1.forest_area1,ft2.forest_area2 ORDER BY forest_difference

-- Highest forest area percent

WITH T1 AS (SELECT country_name,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100 )AS forest_area1
FROM forestation
WHERE year ='1990'
GROUP BY country_name,region,forest_area_sqkm,total_area_sq_mi),
T2 AS (SELECT country_name,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100) AS forest_area2
FROM forestation
   WHERE year='2016'
GROUP BY country_name,region,forest_area_sqkm,total_area_sq_mi) SELECT f.country_name,f.region,ROUND((((f.forest_area1 - t.forest_area2)/(f.forest_area1))*100)::Numeric,2) as forest_difference
FROM T1 f
JOIN T2 t
ON f.country_name = t.country_name
WHERE f.forest_area1 IS NOT NULL AND t.forest_area2 IS NOT NULL AND f.country_name !='World'
GROUP BY f.country_name,f.region,f.forest_area1,t.forest_area2
ORDER BY forest_difference
LIMIT 5

-- B .LARGEST CONCERN
-- 5 countries saw the largest amount decrease in forest area from 1990 to 2016

WITH T1 AS (SELECT country_name,region,SUM(forest_area_sqkm)AS forest_area1 FROM forestation
WHERE year ='1990'
GROUP BY country_name,region,forest_area_sqkm),
T2 AS (SELECT country_name,region,SUM(forest_area_sqkm) AS forest_area2
FROM forestation
WHERE year='2016'
GROUP BY country_name,region,forest_area_sqkm)
SELECT ft1.country_name,ft1.region,(ft1.forest_area1 - ft2.forest_area2) as forest_difference FROM T1 ft1
JOIN T2 ft2
ON ft1.country_name = ft2.country_name
WHERE ft1.forest_area1 IS NOT NULL AND ft2.forest_area2 IS NOT NULL AND ft1.country_name !='World'
GROUP BY ft1.country_name,ft1.region,ft1.forest_area1,ft2.forest_area2 ORDER BY forest_difference DESC
LIMIT 5

-- Top 5 Percent Decrease in Forest Area by Country, 1990 & 2016

WITH T1 AS (SELECT country_name,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100 )AS forest_area1
FROM forestation
WHERE year ='1990'
GROUP BY country_name,region,forest_area_sqkm,total_area_sq_mi),
T2 AS (SELECT country_name,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100) AS forest_area2
FROM forestation
  WHERE year='2016'
GROUP BY country_name,region,forest_area_sqkm,total_area_sq_mi) SELECT f.country_name,f.region,ROUND((((f.forest_area1 - t.forest_area2)/(f.forest_area1))*100)::Numeric,2) as forest_difference
FROM T1 f
JOIN T2 t
ON f.country_name = t.country_name
WHERE f.forest_area1 IS NOT NULL AND t.forest_area2 IS NOT NULL AND f.country_name !='World'
GROUP BY f.country_name,f.region,f.forest_area1,t.forest_area2
ORDER BY forest_difference DESC
LIMIT 5

-- C.Quartiles
-- quartile grouping

WITH T1 AS (SELECT country_name,year,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100 )AS forest_area1
FROM forestation
WHERE year ='2016'
GROUP BY country_name,year,region,forest_area_sqkm,total_area_sq_mi)
SELECT DISTINCT(quartile),COUNT(country_name) OVER (PARTITION BY quartile) FROM (SELECT country_name, CASE WHEN forest_area1 <25 THEN '1st' WHEN forest_area1 >=25 AND forest_area1 < 50 THEN '2nd' WHEN forest_area1 >=50 AND forest_area1 <75 THEN '3rd' ELSE '4th' END AS quartile
FROM T1
WHERE forest_area1 IS NOT NULL AND year ='2016') case_quartile
--list of 9 countries in 4th quartile
WITH T1 AS (SELECT country_name,year,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100 )AS forest_area1
FROM forestation
WHERE year ='2016'
GROUP BY country_name,year,region,forest_area_sqkm,total_area_sq_mi)
SELECT country_name, CASE WHEN forest_area1 <25 THEN '1st' WHEN forest_area1 >=25 AND forest_area1 < 50 THEN '2nd' WHEN forest_area1 >=50 AND forest_area1 <75 THEN '3rd' ELSE '4th' END AS quartile
FROM T1
WHERE forest_area1 >75 AND year ='2016' AND country_name !='World'
  
-- count of countries had percent higher than US in 2016

WITH T1 AS (SELECT country_name,year,region,((SUM(forest_area_sqkm)/SUM(total_area_sq_mi * 2.59))*100 )AS forest_area1
FROM forestation
WHERE year ='2016'
GROUP BY country_name,year,region,forest_area_sqkm,total_area_sq_mi)
SELECT count(*)
FROM T1
WHERE forest_area1 > (SELECT forest_area1
FROM T1
WHERE country_name ='United States' AND year ='2016')