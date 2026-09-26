# Claude — Global

<!-- markdownlint-disable MD041 -->

Persona, memory policy and orchestration policy are pinned Naminé notes and
arrive in tier 1 at session start. ADR conventions are the `adr-conventions`
skill: `get` it before writing an ADR. If tier 1 did not arrive, call the
`namine` MCP `context` tool with `full: true` before anything else.

<!-- markdownlint-disable MD041 -->

## Principles

- Assume security comes first unless otherwise stated.

<!-- markdownlint-disable MD041 -->

## Host-local context

If `~/.ai/local.md` exists on this machine, it describes environment-specific
facts (network, hosting, reachability). Treat it as ground truth for this host.

@local.md

<!-- markdownlint-disable MD041 -->

## User Context

- Development workloads are on the cloud; only the Terminal is local.
- Prefers config in pure bash scripts.
- Lives in Malaysia (UTC+8); give cost estimates in both USD and MYR.
