<!-- markdownlint-disable MD041 -->

Persona, memory policy and orchestration policy are pinned Naminé notes and
arrive in tier 1 at session start. ADR conventions are the `adr-conventions`
skill: `get` it before writing an ADR. If tier 1 did not arrive, call the
`namine` MCP `context` tool with `full: true` before anything else.
