# Welcome to my .dotfiles!
All the files in here are run according to sorting order upon running the `bin/dotfiles` script.

## First Time Install
Run the script below:

```
bash <(curl -H "Cache-Control: no-cache, no-store" -sL https://raw.githubusercontent.com/aykhaiweng/dotfiles/refs/heads/main/bin/dotfiles)
```

## AI Memory

Persistent AI memory (laws, persona, preferences, per-project notes) lives in
Naminé (`~/Projects/namine-dev/namine`), not in dotfiles. `bin/namine` shims
its CLI; `namine setup --tool claude-code` registers the hooks and MCP server.

`bin/compile-ai-configs` generates the per-tool configs from the `ai/`
fragments. `CLAUDE.md` is only a pointer to Naminé. Gemini, Antigravity and
Qwen can't reach Naminé yet, so they get the fragments inlined, with the laws
from `ai/laws.md` — a committed cache the compiler refreshes from Naminé's
global law notes whenever the `namine` CLI can reach its server. Edit laws in
Naminé, then run the compiler.

## Claude Code settings

`~/.claude/settings.json` links to `link/.claude/settings.json`, which is
generated and untracked. `bin/claude-settings-merge` (run last by
`bin/compile-ai-configs`) builds it by deep-merging two files, the second
winning on conflicts:

- `link/.claude/settings.base.json` (tracked): everything portable: hooks,
  plugins, models, permissions. Write paths as `$HOME/...`; the merge
  substitutes this machine's home.
- `link/.claude/settings.machine.json` (untracked): this machine's paths
  (`permissions.additionalDirectories`) and anything confidential
  (`autoMode`, which holds client details). Objects merge key by key; arrays
  replace, so keep each array in one file.

Claude Code writes to `settings.json` itself (`/config`, `/model`, "always
allow", `namine setup`). If it changed since the last build, the merge stops
and prints the diff instead of overwriting it: move the changes into the base
or machine file and rerun, or drop them with
`CLAUDE_SETTINGS_FORCE=1 bin/claude-settings-merge`. To see those changes at any
time without building, run `bin/claude-settings-merge --diff`.

On a new machine, create `settings.machine.json`, then run the merge once with
`CLAUDE_SETTINGS_FORCE=1`, since the existing `settings.json` won't match a
build yet. Tests: `tests/claude-settings/run.sh`.

## Known Issues
### Google Axion running Ubuntu 24.04 LTS
You're gonna need to `sudo apt update` and `sudo apt upgrade` before attempting to run this script.
