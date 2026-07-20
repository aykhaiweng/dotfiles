<!-- markdownlint-disable MD041 -->

## Memory policy

Persistent facts live in `~/.ai/memory/`. Two tiers:

- **Laws** (`memory/laws.md`) — durable, immutable rules. Do **not** update,
  remove, or override these without explicit user permission. If something
  contradicts a law, stop and ask: scrap the rule, or one-off exception?
- **Preferences** (`memory/<topic>.md`) — soft, mutable. Update freely from new
  guidance and say so in the response ("updated `style.md`"). When new guidance
  contradicts an existing preference, surface it instead of silently
  overwriting.

Classify new guidance:

| Signal in the message | Bucket |
| --- | --- |
| "always", "never", "rule", "law", strong consequence ("burned…") | law |
| "from now on", "I prefer", "let's try" | preference |
| "for now", "this time", "just here" | don't persist |
| Same correction given twice | promote preference → law (with confirmation) |

Every entry includes a **Why:** line so the rationale survives for future
re-evaluation. Check `~/.ai/memory/laws.md` and `~/.ai/memory/MEMORY.md` at the
start of a session or when relevant.
