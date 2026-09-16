-- Listing counts and average price by area type
SELECT area_type, COUNT(*) AS listings, ROUND(AVG(price), 2) AS avg_price
FROM 'data/Bengaluru_House_Data.csv'
GROUP BY area_type
ORDER BY listings DESC;

-- Most expensive localities with a meaningful sample size
SELECT location, COUNT(*) AS listings, ROUND(AVG(price), 2) AS avg_price
FROM 'data/Bengaluru_House_Data.csv'
GROUP BY location
HAVING COUNT(*) > 50
ORDER BY avg_price DESC
LIMIT 15;

-- Completeness check on society: nulls vs empty strings
SELECT COUNT(*) AS total,
       COUNT(society) AS non_null,
       COUNT(DISTINCT society) AS distinct_values,
       SUM(CASE WHEN society = '' THEN 1 ELSE 0 END) AS empty_strings
FROM 'data/Bengaluru_House_Data.csv';