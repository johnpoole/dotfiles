Quick row count and latest timestamp for tables. Read `~/.claude/local/connections.md` for sqlcmd path and server.

The user provides: $ARGUMENTS

This should be a database name and optionally table name(s) or schema filter.

## Steps

1. If only a database name is given, list all tables with row counts:
   ```sql
   SELECT s.name AS [schema], t.name AS [table],
          SUM(p.rows) AS row_count
   FROM sys.tables t
   JOIN sys.schemas s ON t.schema_id = s.schema_id
   JOIN sys.partitions p ON t.object_id = p.object_id AND p.index_id IN (0,1)
   GROUP BY s.name, t.name
   ORDER BY s.name, t.name
   ```

2. If a specific table is given, also find the latest timestamp:
   - First check which columns look like timestamps:
     ```sql
     SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = '<table>' AND DATA_TYPE IN ('datetime','datetime2','date','datetimeoffset')
     ```
   - Then query `MAX(<timestamp_col>)` for each datetime column found.

3. Present results as a table with row counts and freshness.
