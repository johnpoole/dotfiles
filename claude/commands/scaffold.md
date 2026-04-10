Bring the current project directory up to current scaffold standards. Works on both new projects (creates everything) and existing projects (adds missing files and sections without overwriting existing content).

## How to run

Work through the checklist in **Idempotent mode rules** below, item by item, regardless of whether `.claude/` already exists. Each item has its own existence check — a file existing does NOT mean its sections are present. Never skip a row because a parent file or directory exists.

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

Work through every row. Each row is an independent check — do not skip a row because a parent file already exists.

| # | Item | How to check | Action if missing |
|---|------|-------------|-------------------|
| 1 | `.claude/CLAUDE.md` | Does the file exist? | Create it with placeholder sections + Advisor Pattern section |
| 2 | `## Advisor Pattern` heading in `.claude/CLAUDE.md` | **Read the file and grep for the exact string `## Advisor Pattern`.** If the grep finds no match, the section is missing — even if the file is large and looks complete. | Append the full Advisor Pattern block (from the section below) to the end of the file. Do not modify any existing content. |
| 3 | `.claude/CLAUDE.local.md` | Does the file exist? | Create empty with comment |
| 4 | `.claude/settings.json` | Does the file exist? | Create with default content |
| 5 | `.claude/settings.local.json` | Does the file exist? | Create with default content |
| 6 | `.claude/rules/testing.md` | Does the file exist? | Create |
| 7 | `.claude/commands/review.md` | Does the file exist? | Create |
| 8 | `.claude/skills/refactor/SKILL.md` | Does the file exist? | Create |
| 9 | `.claude/agents/reviewer.md` | Does the file exist? | Create |
| 10 | `.claude/agents/advisor.md` | Does the file exist? | Create |

Row 2 always runs — even when row 1 was skipped because CLAUDE.md already existed. A file existing is not evidence that its sections are present.

Never merge, diff, or partially edit any file except CLAUDE.md (where only a missing section is appended). All other files: either they exist (skip) or they don't (create).

## After creating

If a .gitignore exists, add `.claude/CLAUDE.local.md` and `.claude/settings.local.json` to it (if not already present).

## Summary output

After finishing, print a summary with three categories:

```
Scaffold complete.

Created:
  ✓ .claude/agents/advisor.md

Updated (file existed, missing sections added):
  ✓ .claude/CLAUDE.md → appended ## Advisor Pattern section

Skipped (up to date):
  – .claude/CLAUDE.md (file exists, ## Advisor Pattern present)
  – .claude/settings.json (file exists)
  – .claude/agents/reviewer.md (file exists)
  ...
```

The "Skipped" entry for CLAUDE.md must confirm that the section was found, not just that the file exists. If you skipped row 2 because the section was present, say so explicitly.

Then tell the user to edit `.claude/CLAUDE.md` with their project-specific details if any placeholders remain.
