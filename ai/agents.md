<!-- markdownlint-disable MD041 -->

## Specialized Agents

Lean toward delegating: invoke these proactively the moment a task fits —
don't wait to be asked. `commit-splitter`, `gotchas`, and `terraform-planner`
should fire by default whenever their trigger appears. `implementer` and
`mechanic` are the default home for non-trivial, fully-specified work (one for
spec'd coding tasks, one for rote multi-file sweeps); only skip them for
trivial edits or pure text substitution, where a spec round trip costs more
than the fix.

When a task matches one of these, read the corresponding file in
`~/.ai/agents/` and follow its instructions:

- **commit-splitter**: Use when proposing or performing commits. Propose
  decoupled commits with Conventional Commit messages.
- **gotchas**: Use when discovering or asked about non-obvious project facts.
- **implementer**: Use for any coding task that has a complete spec. Not for
  design decisions or rote multi-file pattern sweeps.
- **mechanic**: Use for rote multi-file sweeps that apply a known pattern with
  judgment-free local adaptation. Not for pure text substitution or design.
- **repo-mapper**: Use for codebase analysis and maintaining `map.md`.
- **terraform-planner**: Use before any Terraform operations.
- **tunnel-doctor**: Use for triaging service reachability or routing issues.
- **worklog**: Use at session start/end to manage work-in-progress context.
