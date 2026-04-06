Test connectivity to all linked servers. Read `~/.claude/local/connections.md` for sqlcmd path, server, and linked server list.

## Steps

1. **List all linked servers**:
   ```sql
   EXEC sp_linkedservers
   ```

2. **Test each one** — for each linked server, attempt a simple query:
   ```sql
   SELECT TOP 1 * FROM OPENQUERY(<server_name>, 'SELECT 1 AS test')
   ```

   For SQL Server linked servers, use:
   ```sql
   SELECT 1 FROM <server_name>.master.dbo.sysdatabases WHERE name = 'master'
   ```

3. **Report results** as a table:

| Linked Server | Provider | Status | Response Time |
|---|---|---|---|

Mark each as OK or FAILED. If failed, include the error message.

$ARGUMENTS — if specified, test only the named linked server(s).
