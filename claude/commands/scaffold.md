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
    ├── reviewer.md
    └── advisor.md
```

## File contents

### CLAUDE.md
Primary project instructions. Create with these sections as TODO placeholders:
- **Build & Run** — build, run, and test commands
- **Architecture** — high-level architecture description
- **Coding Conventions** — naming, formatting, error handling
- **Gotchas** — non-obvious behaviors and known issues

Also include a literal **Advisor Pattern** section (not a placeholder — include the full content below):

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
An Opus-backed advisor agent for the Claude advisor pattern. See the **Advisor Pattern** section in CLAUDE.md for usage.

The file should contain:
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

## After creating

If a .gitignore exists, add `.claude/CLAUDE.local.md` and `.claude/settings.local.json` to it (if not already present).

Tell the user to edit `.claude/CLAUDE.md` first with their project-specific details.
