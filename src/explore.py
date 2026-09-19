"""Run a .sql file against the Bengaluru housing dataset via DuckDB.

Usage:
    python src/explore.py                     # defaults to sql/01_explore.sql
    python src/explore.py sql/02_quality.sql
    python src/explore.py sql/03_clean_sqft.sql
    python src/explore.py sql/04_clean_size.sql
"""

import sys
import duckdb

DEFAULT_SQL = "sql/01_explore.sql"


def load_queries(path):
    with open(path) as f:
        return [q.strip() for q in f.read().split(";") if q.strip()]


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_SQL
    queries = load_queries(path)
    print(f"Running {len(queries)} queries from {path}")

    for i, q in enumerate(queries, start=1):
        header = q.splitlines()[0].lstrip("- ").strip()
        print(f"\n[{i}/{len(queries)}] {header}")
        duckdb.sql(q).show()


if __name__ == "__main__":
    main()