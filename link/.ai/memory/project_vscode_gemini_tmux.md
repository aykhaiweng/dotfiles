---
name: project_vscode_gemini_tmux
description: Gemini CLI IDE integration fix — TERM_PROGRAM must be vscode inside tmux sessions
metadata:
  type: project
---

Gemini CLI detects VSCode by checking `process.env["TERM_PROGRAM"] === "vscode"`. Tmux sessions don't inherit this from the parent VSCode terminal, so IDE integration silently fails.

**Fix applied** to `~/Library/Application Support/Code/User/settings.json` `gemini-tmux` profile: pass `-e "TERM_PROGRAM=vscode"` to both `tmux new-session` and `tmux new-window`, and run `tmux set-environment -t "$SESSION_NAME" TERM_PROGRAM vscode` before attaching to an existing session.

**Why:** Unlike Claude Code (which uses `VSCODE_IPC_HOOK_CLI` directly), Gemini CLI gates its entire IDE feature on the `TERM_PROGRAM` check.

**How to apply:** If the gemini-tmux terminal profile is ever rebuilt or the settings.json is reset, remember to include `TERM_PROGRAM=vscode` in all tmux `-e` flags. Same fix applies to any other AI CLI that checks `TERM_PROGRAM` instead of `VSCODE_IPC_HOOK_CLI`.
