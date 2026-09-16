# SQL Log

## W1D1 — Mon 14 Sep 2026 — Basic joins

| # | Problem | Pattern | Note |
|---|---|---|---|
| 1378 | Replace Employee ID With The Unique Identifier | LEFT JOIN | LEFT not INNER — employees with no unique ID must still appear as NULL |
| 1068 | Product Sales Analysis I | INNER JOIN on product_id | Straightforward lookup join |
| 1581 | Customer Who Visited but Did Not Make Any Transactions | LEFT JOIN + WHERE IS NULL | Anti-join pattern. Filter goes in WHERE after the join; used <> which wrong and put where before from and =null wrong and groupby +count(*) |
| 197 | Rising Temperature | Self-join on date offset | Same table twice with aliases. DATEDIFF = 1, not just id - 1 or interval 1 day |
| 1661 | Average Time of Process per Machine | Self-join on activity_type |  Pivot start/end onto one row before subtracting |

**Concept of the day:** a join filters and multiplies at the same time. If the key isn't unique on the right side, row count goes up. when iterate same table, self join.

**Struggled with:** 1581 for using <> which which is very wrong and 197 for self+function

## W1D2 — Tue 15 Sep 2026 — Joins into aggregation

| # | Problem | Pattern | Note |
|---|---|---|---|
| 577 | Employee Bonus | LEFT JOIN + IS NULL | Anti-join again. Same shape as 1581, different clothes |
| 1280 | Students and Examinations | CROSS JOIN + LEFT JOIN | Build the full student×subject grid first, then attach actual exams |
| 570 | Managers with at Least 5 Direct Reports | Self-join + GROUP BY + HAVING | First HAVING. Count after grouping, not in WHERE |
| 1934 | Confirmation Rate | LEFT JOIN + AVG over CASE | Users with no requests still need a row, rate rounds to 2dp |
| 1251 | Average Selling Price | JOIN on date range + weighted avg | Join condition is BETWEEN, not equality. SUM(price*units)/SUM(units) |

**Concept of the day:** WHERE filters rows before grouping, HAVING filters groups after aggregation. Order is FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY, which is why a SELECT alias can be used in ORDER BY but not in WHERE or HAVING.

**Struggled with:** Stuck mainly on (CASE WHEN inside AVG()), understanding how it processes every row within each GROUP BY. Also got stuck on LEFT JOIN + WHERE, especially why putting conditions in WHERE can remove unmatched NULL rows.

**Build:** DuckDB installed, Bengaluru house price dataset profiled. society is 41% NULL (5,502 of 13,320), 2,688 distinct values, zero empty strings — so the gaps are true NULLs.