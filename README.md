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

## Known Issues
### Google Axion running Ubuntu 24.04 LTS
You're gonna need to `sudo apt update` and `sudo apt upgrade` before attempting to run this script.
