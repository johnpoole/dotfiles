Check SQL Agent job status. Read `~/.claude/local/connections.md` for sqlcmd path and server.

Run this query against `msdb`:

```sql
SELECT j.name,
       j.enabled,
       CASE h.run_status WHEN 0 THEN 'FAILED' WHEN 1 THEN 'OK' WHEN 3 THEN 'CANCELLED' WHEN 4 THEN 'RUNNING' ELSE 'UNKNOWN' END AS last_status,
       CAST(STUFF(STUFF(CAST(h.run_date AS VARCHAR),5,0,'-'),8,0,'-') + ' ' + STUFF(STUFF(RIGHT('000000'+CAST(h.run_time AS VARCHAR),6),3,0,':'),6,0,':') AS DATETIME) AS last_run,
       h.run_duration
FROM msdb.dbo.sysjobs j
OUTER APPLY (
    SELECT TOP 1 run_status, run_date, run_time, run_duration
    FROM msdb.dbo.sysjobhistory
    WHERE job_id = j.job_id AND step_id = 0
    ORDER BY run_date DESC, run_time DESC
) h
WHERE j.enabled = 1
ORDER BY last_status, j.name
```

If `$ARGUMENTS` contains a keyword, add `AND j.name LIKE '%<keyword>%'` to the WHERE clause.

Present results as a table. Lead with failures.
