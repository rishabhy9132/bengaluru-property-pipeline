# Bengaluru Property Pipeline

End-to-end data pipeline: public property listings → cloud storage →
transformation → analytics layer.

## Architecture
TODO

## Stack
DuckDB · SQL · Python 3.13 · Git

## Data
Source: Bengaluru House Price Data (Kaggle).
Download the CSV and place it at `data/Bengaluru_House_Data.csv`.
The `data/` directory is gitignored — no raw data is committed.

## Status
Week 1 — project initialised.

## Running

```bash
source .venv/bin/activate
python src/explore.py                     # exploration queries
python src/explore.py sql/02_quality.sql  # data quality profile
```

## Data quality notes

Source profiled before any transformation logic was written.
13,320 rows, 9 columns, single CSV.

- **`society` is 41.31% NULL** — 5,502 of 13,320 rows. Verified as true NULLs,
  not empty strings. Unusable as a required field: an inner join on society
  would silently drop four listings in ten.
- **`total_sqft` imports as VARCHAR, not numeric.** 247 values (1.9%) fail a
  numeric cast — ranges (`2249.81 - 4112.19`) and mixed units (`142.61Sq. Meter`,
  also Perch and Sq. Yards). Any area-based metric needs parsing and unit
  conversion first.
- **`size` uses three vocabularies for one concept** — 32 distinct values across
  `BHK` (5,199 for 2 BHK, 4,310 for 3 BHK), `Bedroom` (826 for 4 Bedroom, 547
  for 3 Bedroom) and `RK`. `2 BHK` and `2 Bedroom` group separately despite
  being equivalent. Must be parsed to a numeric bedroom count plus a unit flag.
- **`area_type` is clean** — 4 values, no nulls: Super built-up (8,790), Built-up
  (2,418), Plot (2,025), Carpet (87). The only field ready to serve as a
  dimension as-is, though Carpet Area at 0.65% of rows is too thin for reliable
  comparison.
- **507 duplicate groups, 744 extra rows** on the composite natural key
  (location, size, total_sqft, bath, balcony, price). No surrogate key in
  source, so a deterministic key must be generated during ingestion.
- **`price` is heavily right-skewed** — mean 112.57 lakh vs median 72.00 lakh,
  range 8 to 3,600. Average price by locality overstates the typical listing;
  median is the correct default measure.
- **Physically implausible extremes across correlated fields** — `max(bath) = 40`,
  alongside `43 Bedroom`, `27 BHK`, `19 BHK`, `18 Bedroom` (1 row each). The
  agreement between bath and size suggests a small set of entry errors or
  commercial listings rather than a single-column glitch. Needs a bounds check
  and a decision: exclude, or flag and retain.
- **`location` has 1,305 distinct values, 1,283 after TRIM + LOWER** — 22 casing
  or whitespace variants of existing localities. Low volume, but must be
  normalised before location becomes a dimension key.
- **Remaining nulls:** `balcony` 4.57% (609), `bath` 0.55% (73), `size` 0.12%
  (16), `location` 0.01% (1). `area_type`, `availability` and `price` are fully
  populated. Note `AVG(balcony)` silently computes over 12,711 rows, not 13,320.