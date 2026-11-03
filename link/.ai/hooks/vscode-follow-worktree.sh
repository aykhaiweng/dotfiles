#!/bin/bash
# Registered twice: as a PostToolUse hook on EnterWorktree (which fires no CwdChanged) and as a CwdChanged
# hook (a cd into a sibling worktree). Both inputs carry the session's new directory as `cwd`.
# When Claude Code runs in VS Code's integrated terminal and the session moves into another git checkout,
# open that checkout in a new VS Code window, as the extension's own "Open worktree" button does.
# It does nothing outside VS Code's terminal, for a cd that stays in the same checkout, or for a
# checkout already opened (or started in) this session, so moving back to the main checkout opens
# nothing. Not `code -r`: reopening the current window restarts its terminals and would end this session.
set -u

[[ "${TERM_PROGRAM:-}" == "vscode" ]] || exit 0
command -v code >/dev/null 2>&1 || exit 0

input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
session=$(jq -r '.session_id // empty' <<<"$input")
[[ -n "$cwd" && -n "$session" ]] || exit 0
top=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0

# One list per session of the checkouts VS Code already shows. The first call seeds it with the checkout
# the session started in (CLAUDE_PROJECT_DIR), which is already open in this window.
state="${TMPDIR:-/tmp}/claude-vscode-follow-$session"
if [[ ! -f "$state" ]]; then
  start=$(git -C "${CLAUDE_PROJECT_DIR:-$cwd}" rev-parse --show-toplevel 2>/dev/null || true)
  : >"$state"
  [[ -n "$start" ]] && printf '%s\n' "$start" >>"$state"
fi
grep -Fxq -- "$top" "$state" && exit 0
printf '%s\n' "$top" >>"$state"

code -n "$top" >/dev/null 2>&1 &
exit 0
