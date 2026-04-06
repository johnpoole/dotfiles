Compare table structure and row counts between two databases or environments. Read `~/.claude/local/connections.md` for sqlcmd path and server.

The user provides: $ARGUMENTS (e.g. "DataParcDev vs DataParcStaging", "PVR PVR_backup")

## Steps

1. Parse input to identify the two databases to compare.

2. **Compare table lists** — find tables in one but not the other:
   ```sql
   SELECT 'Only in <db1>' AS location, TABLE_SCHEMA, TABLE_NAME
   FROM <db1>.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
   AND TABLE_SCHEMA + '.' + TABLE_NAME NOT IN (
       SELECT TABLE_SCHEMA + '.' + TABLE_NAME FROM <db2>.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
   )
   UNION ALL
   SELECT 'Only in <db2>', TABLE_SCHEMA, TABLE_NAME
   FROM <db2>.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
   AND TABLE_SCHEMA + '.' + TABLE_NAME NOT IN (
       SELECT TABLE_SCHEMA + '.' + TABLE_NAME FROM <db1>.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
   )
   ```

3. **Compare row counts** for shared tables:
   ```sql
   SELECT t1.TABLE_SCHEMA, t1.TABLE_NAME,
          p1.rows AS <db1>_rows, p2.rows AS <db2>_rows,
          p1.rows - p2.rows AS delta
   FROM <db1>.INFORMATION_SCHEMA.TABLES t1
   JOIN <db1>.sys.partitions p1 ON OBJECT_ID('<db1>.' + t1.TABLE_SCHEMA + '.' + t1.TABLE_NAME) = p1.object_id AND p1.index_id IN (0,1)
   JOIN <db2>.INFORMATION_SCHEMA.TABLES t2 ON t1.TABLE_SCHEMA = t2.TABLE_SCHEMA AND t1.TABLE_NAME = t2.TABLE_NAME
   JOIN <db2>.sys.partitions p2 ON OBJECT_ID('<db2>.' + t2.TABLE_SCHEMA + '.' + t2.TABLE_NAME) = p2.object_id AND p2.index_id IN (0,1)
   WHERE t1.TABLE_TYPE = 'BASE TABLE'
   ORDER BY ABS(p1.rows - p2.rows) DESC
   ```

4. **Compare column definitions** for shared tables — flag any where column types, nullability, or column count differs.

5. **Present results**:
   - Tables only in db1
   - Tables only in db2
   - Shared tables with row count differences (sorted by largest delta)
   - Schema mismatches if any
