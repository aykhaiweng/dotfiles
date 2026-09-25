<!-- markdownlint-disable MD041 -->

## Memory policy

Persistent memory is Naminé: the `namine` MCP server plus hooks. Laws and
pinned notes arrive as tier 1 at session start; the note index comes from the
`context` tool; capture goes through `remember`. Two tiers:

- **Laws** — durable rules, delivered at every session start. I do **not**
  update, remove, or override these without explicit user permission; an
  agent write to a law opens a proposal the user approves. If something
  contradicts a law, I stop and ask: scrap the rule, or one-off exception?
- **Preferences** and facts — soft, mutable. I capture them with `remember`
  and say so in the response ("remembered `style`"). When new guidance
  contradicts an existing note, I surface it instead of silently superseding.

How I classify new guidance:

| Signal in your message | Bucket |
| --- | --- |
| "always", "never", "rule", "law", strong consequence ("burned…") | law |
| "from now on", "I prefer", "let's try" | preference |
| "for now", "this time", "just here" | don't persist |
| Same correction given twice | promote preference → law (with confirmation) |

Every law and preference carries a **Why:** so the rationale survives for
future re-evaluation.

## Orchestration policy

- The main session owns planning, architecture, and design decisions.
- Delegate to subagents when a task is fully specifiable AND non-trivial
  in size, or when tasks are parallelizable: implementation work goes to
  `implementer`, rote multi-file pattern application to `mechanic`.
  Trivial edits: just do them directly — a spec round trip costs more
  than the fix.
- Pure text substitution (renames, literal swaps) is `sed`/`grep`/LSP
  territory. No agent, no LLM.
- Before delegating, produce a complete spec: files to touch, function
  signatures, edge cases resolved, acceptance criteria, and the exact
  verification command (build/test/grep) the agent must run. A subagent
  should never need to make a design decision.
- When a subagent returns a blocker report, resolve the decision
  yourself, fold its completed work into an updated spec, and
  re-dispatch. Re-dispatched agents are fresh — they remember nothing —
  so the spec must be self-contained. Do not let subagents improvise
  past ambiguity.

## Host-local context

If `~/.ai/local.md` exists on this machine, it describes environment-specific
facts (network, hosting, reachability). Treat it as ground truth for this
host.

@local.md
