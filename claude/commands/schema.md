Describe a database object's schema. Read `~/.claude/local/connections.md` for sqlcmd path and server.

The user provides: $ARGUMENTS (format: `database.schema.object` or `database object` or just `object`)

## Steps

1. Parse the input to determine database, schema, and object name. Default schema is `dbo`.

2. Determine object type — check if it's a table, view, or stored procedure:
   ```sql
   SELECT type_desc FROM sys.objects WHERE name = '<object>'
   ```

3. Based on type:

   **Table or View**:
   ```sql
   SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_NAME = '<object>' AND TABLE_SCHEMA = '<schema>'
   ORDER BY ORDINAL_POSITION
   ```
   Also show indexes:
   ```sql
   SELECT i.name, i.type_desc, i.is_unique, i.is_primary_key,
          STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS columns
   FROM sys.indexes i
   JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
   JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
   WHERE i.object_id = OBJECT_ID('<schema>.<object>')
   GROUP BY i.name, i.type_desc, i.is_unique, i.is_primary_key
   ```
   And row count:
   ```sql
   SELECT SUM(rows) FROM sys.partitions WHERE object_id = OBJECT_ID('<schema>.<object>') AND index_id IN (0,1)
   ```

   **Stored Procedure or View definition**:
   ```sql
   EXEC sp_helptext @objname = N'<schema>.<object>'
   ```

4. Present the schema clearly with column types, nullability, keys, and indexes.
