Bring the current project directory up to current scaffold standards. Works on both new projects (creates everything) and existing projects (adds missing files and sections without overwriting existing content).

## How to run

1. Check whether `.claude/` exists.
   - If it does **not** exist: create the full structure (all files below), then jump to **After creating**.
   - If it does exist: run in **idempotent mode** — check each file and section individually. Add what is missing; skip what already exists. Track every decision.

## Target structure

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
    ├── reviewer.md
    └── advisor.md
```

## File contents (use these when creating from scratch or adding a missing file)

### CLAUDE.md
Primary project instructions. Create with these sections as TODO placeholders:
- **Build & Run** — build, run, and test commands
- **Architecture** — high-level architecture description
- **Coding Conventions** — naming, formatting, error handling
- **Gotchas** — non-obvious behaviors and known issues

Also include the full **Advisor Pattern** section (see below — this is not a placeholder).

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

### agents/advisor.md
```markdown
---
name: advisor
description: Opus-backed advisor. Call before committing to an approach, when stuck, or before declaring a task done.
model: claude-opus-4-6
tools: []
---

You are a senior advisor reviewing work in progress. You receive the full conversation history automatically — the task, every tool call made, every result seen.

Your role:
- Identify misunderstandings of the task before work goes in the wrong direction
- Catch silent failures, missing error handling, and over-engineering
- Flag when an approach won't work or has a simpler alternative
- Verify completion: does the deliverable actually satisfy the request?

Be direct. No filler. If the work is on track, say so briefly. If something is wrong, say exactly what and why.
```

## Advisor Pattern section (for CLAUDE.md)

This block must appear in CLAUDE.md. In idempotent mode: read the existing CLAUDE.md and check whether a `## Advisor Pattern` heading exists. If it does not, append this section verbatim. If it does exist, skip it.

```markdown
## Advisor Pattern

This project uses the Claude advisor pattern. When building agents or API integrations, pair a Sonnet/Haiku executor with an Opus advisor:

### Tool Definition
\`\`\`json
{
    "type": "advisor_20260301",
    "name": "advisor",
    "model": "claude-opus-4-6"
}
\`\`\`

### System Prompt Guidance for Coding Tasks

Prepend to executor system prompt:

\`\`\`
You have access to an `advisor` tool backed by a stronger reviewer model. It takes NO parameters — when you call advisor(), your entire conversation history is automatically forwarded. They see the task, every tool call you've made, every result you've seen.

Call advisor BEFORE substantive work — before writing, before committing to an interpretation, before building on an assumption. If the task requires orientation first (finding files, fetching a source, seeing what's there), do that, then call advisor. Orientation is not substantive work. Writing, editing, and declaring an answer are.

Also call advisor:
- When you believe the task is complete. BEFORE this call, make your deliverable durable: write the file, save the result, commit the change.
- When stuck — errors recurring, approach not converging, results that don't fit.
- When considering a change of approach.

On tasks longer than a few steps, call advisor at least once before committing to an approach and once before declaring done.
\`\`\`

### Cost Control
- Use `max_uses` to cap advisor calls per request
- Enable `caching: {"type": "ephemeral", "ttl": "5m"}` for conversations with 3+ advisor calls
- For conversation-level budgets, count calls client-side
- Beta header required: `advisor-tool-2026-03-01`
```

## Idempotent mode rules

For each item below, check existence first — never overwrite:

| Item | Check | Action if missing |
|------|-------|-------------------|
| `CLAUDE.md` | File exists? | Create with placeholder sections + Advisor Pattern |
| `## Advisor Pattern` in CLAUDE.md | Heading present in file? | Append the section to end of file |
| `CLAUDE.local.md` | File exists? | Create empty with comment |
| `settings.json` | File exists? | Create with default content |
| `settings.local.json` | File exists? | Create with default content |
| `rules/testing.md` | File exists? | Create |
| `commands/review.md` | File exists? | Create |
| `skills/refactor/SKILL.md` | File exists? | Create |
| `agents/reviewer.md` | File exists? | Create |
| `agents/advisor.md` | File exists? | Create |

Never merge, diff, or partially edit any file except CLAUDE.md (where only a missing section is appended). All other files: either they exist (skip) or they don't (create).

## After creating

If a .gitignore exists, add `.claude/CLAUDE.local.md` and `.claude/settings.local.json` to it (if not already present).

## Summary output

After finishing, print a two-column summary:

```
Scaffold complete.

Added:
  ✓ .claude/agents/advisor.md
  ✓ .claude/CLAUDE.md → appended ## Advisor Pattern section

Skipped (already exists):
  – .claude/CLAUDE.md
  – .claude/settings.json
  – .claude/agents/reviewer.md
  ...
```

Then tell the user to edit `.claude/CLAUDE.md` with their project-specific details if any placeholders remain.
