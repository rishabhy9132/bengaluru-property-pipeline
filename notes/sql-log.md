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
## W1D3 — Wed 17 Sep 2026 — Aggregation

| # | Problem | Pattern | Note |
|---|---|---|---|
| 1075 | Project Employees I | GROUP BY + ROUND | Join then group, round to 2dp |
| 1633 | Percentage of Users Attended a Contest | Scalar subquery as denominator | Total user count comes from a separate query inside SELECT |
| 1211 | Queries Quality and Percentage | Two aggregates, one conditional | Integer division trap — multiply by 100.0 to force float |
| 1193 | Monthly Transactions I | GROUP BY derived value + conditional SUM | Group on formatted date (YYYY-MM), not raw timestamp |
| 1174 | Immediate Food Delivery II | Conditional aggregation over filtered set | Ratio via AVG(CASE WHEN ... THEN 1.0 ELSE 0 END) |

**Concept of the day:** conditional aggregation. `SUM(CASE WHEN x THEN 1 ELSE 0 END)` counts matching rows; `AVG(CASE WHEN x THEN 1.0 ELSE 0 END)` gives the ratio directly. WHERE filters the whole query, so it can't give you "matching count" and "total count" side by side — CASE inside the aggregate lets each column carry its own filter.

**Struggled with:** Mainly on LEFT JOIN + WHERE vs ON, conditional aggregation, and for 1174, how to get the complete row corresponding to each customer's MIN(order_date) rather than just finding the minimum date.

**Build:** Data quality profile of the Bengaluru dataset. 9 documented defects — society 41.31% null, total_sqft non-numeric in 247 rows (ranges + mixed units), 507 duplicate groups / 744 extra rows on composite key, price right-skewed (mean 112.57 vs median 72.00), implausible extremes (max bath 40, 43 Bedroom), 22 location casing variants. Committed