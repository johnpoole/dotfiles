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

## Fail loudly — NO SILENT FAILURES

**This is the #1 rule. It overrides every other consideration including convenience, cleanliness, and speed. Every violation has cost real hours of wasted time across multiple projects. This is not theoretical.**

### The absolute rule

If something is wrong, the program stops and tells the user what happened. No exceptions. No "it's just a warning." No "it'll probably be fine." No degraded mode unless the user explicitly asked for one.

### What "silent failure" means — recognize ALL of these patterns

Every one of these is a silent failure. I have written every one of these. Do not write any of them:

1. **Catch-and-continue**: `except Exception: pass` or `except: log.warning(...)` then keep running
2. **Warn-and-proceed**: Print/log that something is wrong, then continue as if it isn't. "Bridge MQTT not connected" printed as a warning while the script happily proceeds to send commands into the void
3. **Debug-level errors**: Logging a real failure at DEBUG so it's invisible at normal log levels. If it can cause the program to malfunction, it is not a DEBUG message
4. **Silent flag-setting**: A background thread detects a fatal problem, sets `self._connected = False`, and nobody checks or acts on it visibly
5. **Fire-and-forget commands**: Sending a command (HTTP request, hardware instruction, API call) and assuming it worked without checking the result or the effect
6. **Optimistic fallbacks**: `value = response.get("key") or default_value` when a missing key means something is actually broken, not that you should use a default
7. **Try/except around the wrong scope**: Wrapping 50 lines in a try/except that catches everything, so you can't tell which line failed or why
8. **Return None instead of raising**: A function that returns None on failure instead of raising, forcing every caller to remember to check

### Preconditions are gates

If a system requires X to function (network connection, hardware link, auth, sensor fix, database, API key), then:
- Check X before proceeding
- If X is missing, **raise an error and stop**. Not a warning. Not a log message. An error that halts execution.
- "Connected but degraded" is not acceptable unless the user explicitly requested a degraded mode

### Commands must be verified

When you send a command to anything external (hardware, API, database, service):
- Check the return value or response status
- When possible, verify the command had its intended effect (e.g., after sending a drive command, confirm odometry changed)
- If verification isn't possible, document why in a code comment

### Logging

- If a condition can cause the program to malfunction or produce wrong results, it is **ERROR** or **WARNING**, never DEBUG
- Background threads that detect failures must surface them to the main thread immediately and visibly — not set a boolean that nobody checks
- All failure information must be visible at the default log level (INFO). The user should never need `--verbose` to find out why something didn't work

### Exception handling

- The only acceptable broad `except` is at the top level of a program's entry point, to format the error message before exit
- Every other `except` must catch a specific exception type and either re-raise, raise a new error, or take a concrete recovery action that is visible in the output
- Never `except Exception as e: logger.error(e)` and continue. That is a silent failure with extra steps
- If you're not sure whether to catch or propagate: **propagate**

### When reviewing code I wrote

Before declaring any task done, scan every function for these patterns. If I wrote `logger.warning(...)` followed by `continue` or no `raise`, that is almost certainly a bug. If I wrote `except` without `raise`, justify why in a comment or fix it.

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

## Agents

Use the `docker-ops` agent for any task involving Docker — container status, logs, restarts, builds, deployments, or docker-compose changes on the Yarbo server. Do not handle Docker tasks inline; delegate to that agent.

## Tone

NEVER use "Fair point.", "Good question.", "Great catch.", "That's a good point.", or any similar validating/patronizing filler phrase. Not as an opener. Not mid-response. Not anywhere. Start with substance. Continue with substance.

Never append follow-up questions to the end of responses. Deliver the answer and stop. Let the user drive the conversation.

## Documentation

- README stays accurate — update it when behaviour changes
- CLAUDE.md captures decisions and rules, not chat history
- Code comments explain *why*, not *what* — if the code is clear, no comment is needed
- Do not add docstrings or comments to code you did not change
