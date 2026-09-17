-- Null count per column, one row per column, worst first
SELECT 'society'      AS column_name, COUNT(*) - COUNT(society)      AS null_count FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'balcony',      COUNT(*) - COUNT(balcony)      FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'bath',         COUNT(*) - COUNT(bath)         FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'size',         COUNT(*) - COUNT("size")       FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'location',     COUNT(*) - COUNT(location)     FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'area_type',    COUNT(*) - COUNT(area_type)    FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'availability', COUNT(*) - COUNT(availability) FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'total_sqft',   COUNT(*) - COUNT(total_sqft)   FROM 'data/Bengaluru_House_Data.csv'
UNION ALL SELECT 'price',        COUNT(*) - COUNT(price)        FROM 'data/Bengaluru_House_Data.csv'
ORDER BY null_count DESC;

-- Duplicate listings: no surrogate key in source, so use a composite natural key
SELECT COUNT(*) AS duplicated_groups,
       SUM(n) - COUNT(*) AS extra_rows
FROM (
  SELECT location, "size", total_sqft, bath, balcony, price, COUNT(*) AS n
  FROM 'data/Bengaluru_House_Data.csv'
  GROUP BY 1,2,3,4,5,6
  HAVING COUNT(*) > 1
);

-- Numeric ranges: mean vs median exposes skew, max_bath exposes outliers
SELECT MIN(price)            AS min_price,
       MAX(price)            AS max_price,
       ROUND(AVG(price), 2)  AS avg_price,
       MEDIAN(price)         AS median_price,
       MIN(bath)             AS min_bath,
       MAX(bath)             AS max_bath
FROM 'data/Bengaluru_House_Data.csv';

-- How many total_sqft values fail a numeric cast?
SELECT COUNT(*) AS total,
       SUM(CASE WHEN TRY_CAST(total_sqft AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS not_numeric
FROM 'data/Bengaluru_House_Data.csv';

-- What do the non-numeric total_sqft values actually look like?
SELECT total_sqft, COUNT(*) AS n
FROM 'data/Bengaluru_House_Data.csv'
WHERE TRY_CAST(total_sqft AS DOUBLE) IS NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;

-- Location cardinality: gap between raw and normalised = casing/whitespace variants
SELECT COUNT(DISTINCT location)                  AS distinct_locations,
       COUNT(DISTINCT TRIM(LOWER(location)))     AS distinct_normalised
FROM 'data/Bengaluru_House_Data.csv';

-- size vocabulary: BHK vs Bedroom vs RK for the same concept
SELECT "size", COUNT(*) AS n
FROM 'data/Bengaluru_House_Data.csv'
GROUP BY 1
ORDER BY 2 DESC;

-- area_type cardinality: low enough to be a clean dimension
SELECT area_type, COUNT(*) AS n
FROM 'data/Bengaluru_House_Data.csv'
GROUP BY 1
ORDER BY 2 DESC;