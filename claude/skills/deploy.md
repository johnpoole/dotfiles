Deploy a Python ETL project. Read `~/.claude/local/connections.md` for staging paths.

The user provides: $ARGUMENTS (project name or path)

## Steps

1. **Find the project** — look in `~/Documents/Github/` for the matching repo.

2. **Read the project's CLAUDE.md** (if it exists) for project-specific deployment instructions. Follow those if present — they override these defaults.

3. **Check git status** — ensure working directory is clean and on the expected branch.

4. **Install dependencies**:
   ```
   pip install -r requirements.txt
   ```

5. **Run tests** (if they exist):
   ```
   pytest
   ```
   If tests fail, stop and report. Do not deploy broken code.

6. **Dry run** — if the project has a dry-run mode, batch file, or `--dry-run` flag, run it and verify output looks correct.

7. **Report** — summarize what was done:
   - Git branch and last commit
   - Dependencies installed
   - Test results
   - Dry run output (if applicable)
   - What manual steps remain (e.g., Jenkins restart, file copy)

Do NOT copy files to production paths or restart services without explicit user confirmation.
