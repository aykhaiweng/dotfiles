# Claude — Global

Persona, memory policy and orchestration policy are pinned Naminé notes and
arrive in tier 1 at session start. ADR conventions are the `adr-conventions`
skill: `get` it before writing an ADR. If tier 1 did not arrive, call the
`namine` MCP `context` tool with `full: true` before anything else.

## Host-local context

If `~/.ai/local.md` exists on this machine, it describes environment-specific
facts (network, hosting, reachability). Treat it as ground truth for this
host.

@local.md
