Check Petrinex pipeline status. Read `~/.claude/local/connections.md` for sqlcmd path and server.

## Steps

1. **Check Petrinex SQL Agent jobs**:
   ```sql
   SELECT j.name,
          CASE h.run_status WHEN 0 THEN 'FAILED' WHEN 1 THEN 'OK' END AS status,
          CAST(STUFF(STUFF(CAST(h.run_date AS VARCHAR),5,0,'-'),8,0,'-') + ' ' + STUFF(STUFF(RIGHT('000000'+CAST(h.run_time AS VARCHAR),6),3,0,':'),6,0,':') AS DATETIME) AS last_run
   FROM msdb.dbo.sysjobs j
   OUTER APPLY (
       SELECT TOP 1 run_status, run_date, run_time FROM msdb.dbo.sysjobhistory
       WHERE job_id = j.job_id AND step_id = 0 ORDER BY run_date DESC, run_time DESC
   ) h
   WHERE j.name LIKE '%petrinex%' OR j.name LIKE '%Petrinex%'
   ORDER BY j.name
   ```

2. **Check data freshness** in the `Petrinex` database:
   ```sql
   SELECT t.TABLE_SCHEMA, t.TABLE_NAME, SUM(p.rows) AS row_count
   FROM Petrinex.INFORMATION_SCHEMA.TABLES t
   JOIN Petrinex.sys.partitions p ON OBJECT_ID('Petrinex.' + t.TABLE_SCHEMA + '.' + t.TABLE_NAME) = p.object_id AND p.index_id IN (0,1)
   WHERE t.TABLE_TYPE = 'BASE TABLE'
   GROUP BY t.TABLE_SCHEMA, t.TABLE_NAME
   ORDER BY t.TABLE_SCHEMA, t.TABLE_NAME
   ```

3. **Check latest submission dates** — look for date columns and find the most recent data per table in the `pd` schema (Petrinex data):
   ```sql
   -- Check key tables for freshness
   SELECT 'pd tables' AS source, TABLE_NAME, COLUMN_NAME
   FROM Petrinex.INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = 'pd' AND DATA_TYPE IN ('datetime','datetime2','date')
   ```
   Then query MAX of each date column found.

4. **Summarize** — report job status, table row counts, and data freshness. Flag any jobs that failed or data that appears stale.

$ARGUMENTS — optional filter or specific question about Petrinex data.
