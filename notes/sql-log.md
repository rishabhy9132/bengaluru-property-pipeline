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

## W1D4 — Thu 17 Sep 2026 — Sorting and grouping

| # | Problem | Pattern | Note |
|---|---|---|---|
| 2356 | Number of Unique Subjects Taught by Each Teacher | COUNT(DISTINCT) + GROUP BY | Count unique subjects per teacher. `dept_id` is in the schema but irrelevant to the answer |
| 1141 | User Activity for the Past 30 Days I | COUNT(DISTINCT) + date filter + GROUP BY | Unique active users per day. Any activity qualifies, so no `activity_type` filter needed |
| 1070 | Product Sales Analysis III | MIN() + subquery + composite `(product_id, year) IN` | Earliest year per product, then all sales in that year. "First year" ≠ "first sale" — multiple rows in the same first year all qualify |
| 596 | Classes With at Least 5 Students | GROUP BY + COUNT + HAVING | Standard group-then-filter shape |
| 1729 | Find Followers Count | GROUP BY + COUNT | Straightforward |

**Concept of the day:** not every column in the schema belongs in the query. `dept_id` in 2356 and `activity_type` in 1141 were both present and both irrelevant. Reading the question for the required grain first, then picking columns, avoids writing a filter or a join that the answer doesn't need.

**Struggled with:** Very little. Only real friction was spotting `COUNT(DISTINCT)` in 2356 after being distracted by irrelevant columns. Pattern recognition was noticeably faster than earlier in the week — GROUP BY + COUNT, COUNT(DISTINCT), and MIN() + subquery all surfaced quickly.

**Build:** None — rescheduled to Saturday Deep Build (total_sqft range parsing).