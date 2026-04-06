Check today's pricing data loads. Read `~/.claude/local/connections.md` for sqlcmd path and server.

## Steps

1. **EKA Pricing** — check `EKAStaging` for today's price entries:
   ```sql
   SELECT IndexName, TradeDate, SettlePrice, LoadDate
   FROM EKAStaging.dbo.TradedIndexSettledPrice
   WHERE TradeDate >= CAST(GETDATE()-1 AS DATE)
   ORDER BY TradeDate DESC, IndexName
   ```
   If no results for today, flag as missing.

2. **Check pricing SQL Agent jobs**:
   ```sql
   SELECT j.name, 
          CASE h.run_status WHEN 0 THEN 'FAILED' WHEN 1 THEN 'OK' END AS status,
          CAST(STUFF(STUFF(CAST(h.run_date AS VARCHAR),5,0,'-'),8,0,'-') AS DATE) AS last_run
   FROM msdb.dbo.sysjobs j
   OUTER APPLY (
       SELECT TOP 1 run_status, run_date FROM msdb.dbo.sysjobhistory
       WHERE job_id = j.job_id AND step_id = 0 ORDER BY run_date DESC, run_time DESC
   ) h
   WHERE j.name LIKE '%price%' OR j.name LIKE '%rack%' OR j.name LIKE '%crack%' OR j.name LIKE '%pricing%'
   ORDER BY j.name
   ```

3. **Commercial tables** — check `Commercial` database for AESO/TC Energy freshness:
   ```sql
   SELECT 'AESO' AS source, MAX(delivery_date) AS latest FROM Commercial.dbo.aeso_forecast
   UNION ALL
   SELECT 'TC Energy', MAX(gas_day) FROM Commercial.dbo.tc_energy_daily
   ```

4. **Summarize** — table showing each pricing source, whether today's data is loaded, and last load timestamp. Flag anything missing or stale.

$ARGUMENTS — if the user specifies a source (e.g. "eka", "aeso", "opis"), filter to that source only.
