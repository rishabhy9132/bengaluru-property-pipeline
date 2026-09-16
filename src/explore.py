import duckdb

with open("sql/01_explore.sql") as f:
    queries = [q.strip() for q in f.read().split(";") if q.strip()]

for q in queries:
    print(f"\n{q.splitlines()[0]}")
    duckdb.sql(q).show()