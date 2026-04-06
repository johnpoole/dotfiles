Check Jenkins job status. Read `~/.claude/local/connections.md` for Jenkins URL if configured.

The user provides: $ARGUMENTS (project name or keyword)

## Steps

1. Find the matching GitHub repo in `~/Documents/Github/` and check for a `Jenkinsfile`.

2. Read the Jenkinsfile to understand:
   - What triggers the job (cron, webhook, manual)
   - What the job does (build, test, deploy)
   - What schedule it runs on

3. Check git log for recent commits and whether they've been pushed.

4. Report:
   - Job trigger/schedule from Jenkinsfile
   - Last commit date and message
   - Whether local is ahead of remote
   - Any obvious issues in the Jenkinsfile config
