-- Pass 1 — classify. Before converting anything, count what you're dealing with:
SELECT
  CASE
    WHEN TRY_CAST(total_sqft AS DOUBLE) IS NOT NULL THEN 'numeric'
    WHEN total_sqft LIKE '%-%'                      THEN 'range'
    WHEN total_sqft LIKE '%Sq. Meter%'              THEN 'sq_meter'
    WHEN total_sqft LIKE '%Perch%'                  THEN 'perch'
    WHEN total_sqft LIKE '%Sq. Yards%'              THEN 'sq_yards'
    WHEN total_sqft LIKE '%Acres%'                  THEN 'acres'
    WHEN total_sqft LIKE '%Cents%'                  THEN 'cents'
    WHEN total_sqft LIKE '%Guntha%'                 THEN 'guntha'
    WHEN total_sqft LIKE '%Grounds%'                THEN 'grounds'
    ELSE 'unhandled'
  END AS sqft_format,
  COUNT(*) AS n
FROM 'data/Bengaluru_House_Data.csv'
GROUP BY 1
ORDER BY 2 DESC;

-- Pass 2 — convert. Ranges become midpoints, units get converted to square feet:
SELECT
  total_sqft,
  CASE
    WHEN TRY_CAST(total_sqft AS DOUBLE) IS NOT NULL
      THEN TRY_CAST(total_sqft AS DOUBLE)
    WHEN total_sqft LIKE '%-%'
      THEN (TRY_CAST(TRIM(SPLIT_PART(total_sqft, '-', 1)) AS DOUBLE)
          + TRY_CAST(TRIM(SPLIT_PART(total_sqft, '-', 2)) AS DOUBLE)) / 2
    WHEN total_sqft LIKE '%Sq. Meter%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Sq. Meter', '') AS DOUBLE) * 10.7639
    WHEN total_sqft LIKE '%Perch%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Perch', '') AS DOUBLE) * 272.25
    WHEN total_sqft LIKE '%Sq. Yards%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Sq. Yards', '') AS DOUBLE) * 9
    WHEN total_sqft LIKE '%Acres%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Acres', '') AS DOUBLE) * 43560
    WHEN total_sqft LIKE '%Cents%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Cents', '') AS DOUBLE) * 435.6
    WHEN total_sqft LIKE '%Guntha%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Guntha', '') AS DOUBLE) * 1089
    WHEN total_sqft LIKE '%Grounds%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Grounds', '') AS DOUBLE) * 2400
  END AS sqft_clean,
  TRY_CAST(total_sqft AS DOUBLE) IS NULL AS sqft_is_estimated
FROM 'data/Bengaluru_House_Data.csv'
WHERE TRY_CAST(total_sqft AS DOUBLE) IS NULL
LIMIT 40;

-- Pass 3 — check. How many rows are still unhandled after the conversion? drop where and limit

WITH cleaned AS (
  SELECT
  total_sqft,
  CASE
    WHEN TRY_CAST(total_sqft AS DOUBLE) IS NOT NULL
      THEN TRY_CAST(total_sqft AS DOUBLE)
    WHEN total_sqft LIKE '%-%'
      THEN (TRY_CAST(TRIM(SPLIT_PART(total_sqft, '-', 1)) AS DOUBLE)
          + TRY_CAST(TRIM(SPLIT_PART(total_sqft, '-', 2)) AS DOUBLE)) / 2
    WHEN total_sqft LIKE '%Sq. Meter%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Sq. Meter', '') AS DOUBLE) * 10.7639
    WHEN total_sqft LIKE '%Perch%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Perch', '') AS DOUBLE) * 272.25
    WHEN total_sqft LIKE '%Sq. Yards%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Sq. Yards', '') AS DOUBLE) * 9
    WHEN total_sqft LIKE '%Acres%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Acres', '') AS DOUBLE) * 43560
    WHEN total_sqft LIKE '%Cents%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Cents', '') AS DOUBLE) * 435.6
    WHEN total_sqft LIKE '%Guntha%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Guntha', '') AS DOUBLE) * 1089
    WHEN total_sqft LIKE '%Grounds%'
      THEN TRY_CAST(REPLACE(total_sqft, 'Grounds', '') AS DOUBLE) * 2400
  END AS sqft_clean,
  TRY_CAST(total_sqft AS DOUBLE) IS NULL AS sqft_is_estimated
FROM 'data/Bengaluru_House_Data.csv'
)
SELECT COUNT(*) AS total,
       SUM(CASE WHEN sqft_clean IS NULL THEN 1 ELSE 0 END) AS still_null,
       SUM(CASE WHEN sqft_is_estimated THEN 1 ELSE 0 END)  AS estimated,
       MIN(sqft_clean), MAX(sqft_clean), MEDIAN(sqft_clean)
FROM cleaned;