# Welcome to my .dotfiles!
All the files in here are run according to sorting order upon running the `bin/dotfiles` script.

## First Time Install
Run the script below:

```
bash <(curl -H "Cache-Control: no-cache, no-store" -sL https://raw.githubusercontent.com/aykhaiweng/dotfiles/refs/heads/main/bin/dotfiles)
```

## AI Memory

Persistent AI state (global memory + per-project agent notes) lives in its own
private repo at `~/.ai/`, kept in sync across machines by a background agent —
not in dotfiles. After the dotfiles install runs, bootstrap it:

```
bin/setup-ai-memory
```

That clones `git@github.com:aykhaiweng/ai-memory.git` into `~/.ai/` (coexisting
with the dotfiles-managed `agents/` and `hooks/` symlinks) and installs a
filesystem-watcher that auto-commits + pushes on every change:

- **macOS**: two launchd agents at `~/Library/LaunchAgents/`:
  - `com.aykhaiweng.ai-memory-sync.plist` — `fswatch` watcher, instant push on local change
  - `com.aykhaiweng.ai-memory-tick.plist` — periodic timer (every 60s by default) that pulls remote changes
- **Linux**: systemd user units at `~/.config/systemd/user/`:
  - `ai-memory-sync.{path,service}` — inotify watcher + sync service
  - `ai-memory-sync.timer` — periodic trigger of the same service; also the recursive catch-all for nested project notes, since systemd `PathModified` does not watch subdirectories
  - Keep running while logged out: `sudo loginctl enable-linger $USER`.

Override the tick interval with `AI_MEMORY_TICK_INTERVAL=30 bin/setup-ai-memory`.

Tracked: `memory/*.md`, `projects/*/notes/**`, `projects/*/memory/**`.
Ignored: Claude Code session transcripts (`projects/*/*.jsonl`), UUID-named
session state dirs, and the dotfiles-managed `agents/` + `hooks/` subdirs.

Manual sync (safe to run anytime): `bin/ai-memory-sync`.
Logs: `/tmp/ai-memory-sync.{log,err}` (macOS) or
`journalctl --user -u ai-memory-sync.service` (Linux).

### Laws: single source

`~/.ai/memory/laws.md` (in the auto-synced ai-memory repo) is canonical — it's
what Claude reads at runtime via the `@MEMORY.md → @laws.md` chain. Edit the
rules there. `bin/compile-ai-configs` derives the committed bootstrap cache
`ai/laws.md` from it (rules only) and inlines that into the `## Laws` sections of
`GEMINI.md`/`ANTIGRAVITY.md`/`QWEN.md`. The compiler only ever writes inside the
dotfiles tree — never into `~/.ai/` — so it can't trip the ai-memory watcher's
auto-push. No hand-syncing; run the compiler after editing laws.

## Known Issues
### Google Axion running Ubuntu 24.04 LTS
You're gonna need to `sudo apt update` and `sudo apt upgrade` before attempting to run this script.
