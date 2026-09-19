-- Which vocabularies does size actually use? 'unhandled' must be zero.
WITH classified AS (
  SELECT "size",
    CASE
      WHEN "size" IS NULL          THEN 'null'
      WHEN "size" LIKE '%BHK%'     THEN 'bhk'
      WHEN "size" LIKE '%Bedroom%' THEN 'bedroom'
      WHEN "size" LIKE '%RK%'      THEN 'rk'
      ELSE 'unhandled'
    END AS size_format
  FROM 'data/Bengaluru_House_Data.csv'
)
SELECT size_format, COUNT(*) AS n
FROM classified
GROUP BY 1
ORDER BY 2 DESC;

-- Extract the bedroom count and normalise the unit.
-- BHK and Bedroom mean the same thing, so both map to BHK.
-- RK is room+kitchen, not a bedroom count, so it stays separate.
SELECT "size",
       TRY_CAST(SPLIT_PART("size", ' ', 1) AS INTEGER) AS bedrooms,
       CASE
         WHEN "size" LIKE '%BHK%'     THEN 'BHK'
         WHEN "size" LIKE '%Bedroom%' THEN 'BHK'
         WHEN "size" LIKE '%RK%'      THEN 'RK'
       END AS unit_type
FROM 'data/Bengaluru_House_Data.csv'
WHERE "size" IS NOT NULL
LIMIT 30;

-- Validate: parse_failures should equal the 16 source nulls and nothing more.
WITH cleaned AS (
  SELECT "size",
         TRY_CAST(SPLIT_PART("size", ' ', 1) AS INTEGER) AS bedrooms,
         CASE
           WHEN "size" LIKE '%BHK%'     THEN 'BHK'
           WHEN "size" LIKE '%Bedroom%' THEN 'BHK'
           WHEN "size" LIKE '%RK%'      THEN 'RK'
         END AS unit_type
  FROM 'data/Bengaluru_House_Data.csv'
)
SELECT unit_type,
       COUNT(*) AS n,
       MIN(bedrooms) AS min_bed,
       MAX(bedrooms) AS max_bed,
       SUM(CASE WHEN bedrooms IS NULL THEN 1 ELSE 0 END) AS parse_failures
FROM cleaned
GROUP BY 1
ORDER BY 2 DESC;

-- Confirm the double-count is fixed: 2 BHK (5,199) and 2 Bedroom (329)
-- previously grouped separately and should now form one group of 5,528.
WITH cleaned AS (
  SELECT TRY_CAST(SPLIT_PART("size", ' ', 1) AS INTEGER) AS bedrooms,
         CASE
           WHEN "size" LIKE '%BHK%'     THEN 'BHK'
           WHEN "size" LIKE '%Bedroom%' THEN 'BHK'
           WHEN "size" LIKE '%RK%'      THEN 'RK'
         END AS unit_type
  FROM 'data/Bengaluru_House_Data.csv'
)
SELECT bedrooms, unit_type, COUNT(*) AS n
FROM cleaned
WHERE bedrooms <= 5
GROUP BY 1, 2
ORDER BY 1, 2;