# Claude — Global Coding Standards

These rules apply to every project. Project-level CLAUDE.md files add to these; they do not replace them.

## Definition of done

Before declaring any task complete, verify every item:

- [ ] Read every file before editing it — never assumed the contents
- [ ] Only changed what was asked for — no unrequested features, flags, refactors, or abstractions
- [ ] Tests written for new or changed logic
- [ ] Full test suite passes
- [ ] Ran the code and verified actual output — did not just say "this should work"
- [ ] Dead code removed — imports, variables, functions made unused by *my* changes
- [ ] No credentials, tokens, or secrets in code, comments, or logs
- [ ] Error messages say what failed, where, and enough context to debug
- [ ] Dependencies pinned if any were added

## Read before modifying

Always read a file before editing it. Never assume the current contents based on memory or earlier reads in the conversation. This applies to code, config, and documentation.

## Only make changes that were asked for

Do not add features, options, or handling that was not explicitly requested:
- No fallback behaviour for missing config or failed dependencies
- No extra flags, modes, or options unless asked
- No additional logging, comments, or docstrings on code that wasn't changed
- No refactoring of surrounding code when fixing a specific bug
- No abstractions or helpers for one-time use

## Fail loudly

If something fails, raise an error with a clear message and a non-zero exit code. Do not:
- Catch an exception and continue as if nothing happened
- Fall back silently to a secondary approach when a primary one fails
- Log a warning and proceed when a hard stop is required

The only acceptable catches are at the top level of a subprocess entry point to format the exit message. Everything else propagates.

## Remove dead code

When a change makes an import, variable, or function unused, remove it. Do not leave orphans. Only remove code that *your change* made dead — do not clean up pre-existing dead code unless asked.

## Pin dependencies

Package manifests (`requirements.txt`, `package.json`, etc.) must use pinned versions. Loose pins mean the environment silently changes on the next install. When adding a dependency, pin it to the currently installed version.

## Verify by running

After making changes, run the code and check actual output. Do not say "this should work." Confirm it does. For code: run the tests. For scripts: run them and inspect the result.

## Error messages

Error messages must be actionable. They should say:
1. What failed
2. Where (file, line, function — whatever is relevant)
3. What to do about it (if known)

A message like "Error: unexpected value" is not acceptable. "Error: expected delivery_date to be date, got str '2026-01-29' in row 14 of icecleared_oil_2026_01_29.xlsx" is.

## Documentation

- README stays accurate — update it when behaviour changes
- CLAUDE.md captures decisions and rules, not chat history
- Code comments explain *why*, not *what* — if the code is clear, no comment is needed
- Do not add docstrings or comments to code you did not change
