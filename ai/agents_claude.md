<!-- markdownlint-disable MD041 -->

## Specialized Agents

Lean toward delegating: invoke these proactively the moment a task fits —
don't wait to be asked. `commit-splitter`, `gotchas`, and `terraform-planner`
should fire by default whenever their trigger appears. `implementer` and
`mechanic` are the default home for non-trivial, fully-specified work (one for
spec'd coding tasks, one for rote multi-file sweeps); only skip them for
trivial edits or pure text substitution, where a spec round trip costs more
than the fix.

Dispatch them with the Agent tool — Claude Code loads their definitions from
`~/.claude/agents/` and already lists every name and trigger in context, so the
roster is not repeated here. Tools without agent dispatch read `agents.md`
instead, which carries the full roster for hand-reading from `~/.ai/agents/`.
