<!-- markdownlint-disable MD041 -->

## Memory policy

Persistent facts live in `~/.ai/memory/`. Two tiers:

- **Laws** (`memory/laws.md`) — durable rules. I do **not** update, remove, or
  override these without explicit user permission. If something contradicts a
  law, I stop and ask: scrap the rule, or one-off exception?
- **Preferences** (`memory/<topic>.md`) — soft, mutable. I update freely from
  new guidance and tell you in the response ("updated `style.md`"). When new
  guidance contradicts an existing preference, I surface it instead of silently
  overwriting.

How I classify new guidance:

| Signal in your message | Bucket |
| --- | --- |
| "always", "never", "rule", "law", strong consequence ("burned…") | law |
| "from now on", "I prefer", "let's try" | preference |
| "for now", "this time", "just here" | don't persist |
| Same correction given twice | promote preference → law (with confirmation) |

Every entry includes a **Why:** line so the rationale survives for future
re-evaluation.

@memory/MEMORY.md

## Host-local context

If `~/.ai/local.md` exists on this machine, it describes environment-specific
facts (network, hosting, reachability). Treat it as ground truth for this
host.

@local.md
