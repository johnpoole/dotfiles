Start or continue a brainstorm session. Captures raw ideas as they come up, unfiltered, in the order they're discussed. No organizing, no polishing, no filtering out "bad" ideas.

## How it works

1. **Starting a new brainstorm:** Create `docs/brainstorm_<topic>.md` in the current project with a header, date, and topic. If `docs/` doesn't exist, create it.

2. **Continuing an existing brainstorm:** If the user names a topic that matches an existing brainstorm file, append to it with a new date/session separator.

3. **During the brainstorm:** After every substantive exchange, append the point to the file immediately. Don't wait until the end. Include:
   - The point as stated (paraphrase is fine, but preserve the meaning)
   - Who raised it (user vs Claude)
   - Critiques and pushback — these are as valuable as the ideas
   - Wrong turns and why they were wrong
   - Questions that weren't answered
   - References to other projects, papers, or prior work mentioned

4. **Format:** Bullet points with dashes. No headers within the session except `---` separators between sessions. No bold, no tables, no structure beyond chronological bullets. Raw is the point.

5. **Ending a brainstorm:** When the user moves to a different topic or says to stop, add a final `---` and a one-line summary count: "N points captured."

## What NOT to do

- Don't organize the points into categories
- Don't create a separate "polished" document
- Don't filter out ideas that seem wrong or contradictory
- Don't add your own analysis or synthesis
- Don't wait until the conversation is over to write the file
- Don't ask the user to confirm each point before writing it

## File naming

`docs/brainstorm_<topic-in-kebab-case>.md`

If the user doesn't name a topic, ask for one. Keep it short (2-4 words).

## Example

```markdown
# Brainstorm — Scoring Metric Redesign
Date: 2026-07-24

---

- (user) What if we used polar coordinates with an extra dimension?
- (user) The extra dimension could be throw index
- (claude) Throw index encodes FGZ status, team, stones remaining
- (user) That sounds like bullshit. What we want is a reference system with a probability distribution that correlates with end outcome.
- (claude) Sparsity concern — combinatorial explosion of board configs
- (user) Sparsity isn't a factor in real curling — stones cluster in predictable patterns
- (user) Missing piece: which arc the shot took. Polar assumes straight paths.

---
6 points captured.
```
