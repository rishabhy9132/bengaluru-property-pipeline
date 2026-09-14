# SQL Log

## W1D1 — Mon 14 Sep 2026 — Basic joins

| # | Problem | Pattern | Note |
|---|---|---|---|
| 1378 | Replace Employee ID With The Unique Identifier | LEFT JOIN | LEFT not INNER — employees with no unique ID must still appear as NULL |
| 1068 | Product Sales Analysis I | INNER JOIN on product_id | Straightforward lookup join |
| 1581 | Customer Who Visited but Did Not Make Any Transactions | LEFT JOIN + WHERE IS NULL | Anti-join pattern. Filter goes in WHERE after the join | used <> which wrong and put where before from and =null wrong and groupby +count(*)
| 197 | Rising Temperature | Self-join on date offset | Same table twice with aliases. DATEDIFF = 1, not just id - 1 | interval 1 day
| 1661 | Average Time of Process per Machine | Self-join on activity_type | Grain is one row per machine. Pivot start/end onto one row before subtracting |

**Concept of the day:** a join filters and multiplies at the same time. If the key isn't unique on the right side, row count goes up.

**Struggled with:** 1581