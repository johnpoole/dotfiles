Create the .claude/ folder structure in the current project directory with the following files and folders. If .claude/ already exists, stop and ask before overwriting anything.

## Structure to create

```
.claude/
├── CLAUDE.md
├── CLAUDE.local.md
├── settings.json
├── settings.local.json
├── rules/
│   └── testing.md
├── commands/
│   └── review.md
├── skills/
│   └── refactor/SKILL.md
└── agents/
    └── reviewer.md
```

## File contents

### CLAUDE.md
Primary project instructions. Create with these sections as TODO placeholders:
- **Build & Run** — build, run, and test commands
- **Architecture** — high-level architecture description
- **Coding Conventions** — naming, formatting, error handling
- **Gotchas** — non-obvious behaviors and known issues

### CLAUDE.local.md
Empty personal overrides file with a comment explaining its purpose. This file is auto-gitignored by Claude.

### settings.json
```json
{
  "$schema": "https://claude.ai/schemas/claude-settings.json",
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

### settings.local.json
Same as settings.json. This file is auto-gitignored by Claude.

### rules/testing.md
A scoped rule with YAML frontmatter targeting `tests/**`, `**/*_test.*`, and `**/*.test.*`. Placeholder for testing conventions.

### commands/review.md
A command that reviews the current git diff for bugs, silent failures, dead code, and missing error handling. Runs `git diff` and summarizes findings as a checklist.

### skills/refactor/SKILL.md
A skill that triggers on refactoring requests. Steps: read target files, run tests for baseline, make changes, re-run tests, remove dead code.

### agents/reviewer.md
A code review subagent using sonnet model with Read, Grep, and Glob tools. Reviews for correctness, silent failures, security issues, and dead code.

## After creating

If a .gitignore exists, add `.claude/CLAUDE.local.md` and `.claude/settings.local.json` to it (if not already present).

Tell the user to edit `.claude/CLAUDE.md` first with their project-specific details.
