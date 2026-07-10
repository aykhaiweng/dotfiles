#!/usr/bin/env bash
# PreToolUse(Bash) guard: enforce the no-push law (~/.ai/memory/laws.md).
# Reads the hook payload on stdin; exit 2 blocks the call and feeds stderr
# back to Claude. Deterministic — does not rely on the model choosing to obey.

payload="$(cat)"
cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // ""')"

# Match `git [global-flags|-C dir]* push` as the subcommand, anywhere in the
# command string (covers `;`, `&&`, `|` chaining). Avoids false positives like
# `git log --grep=push` by requiring push in subcommand position.
if printf '%s' "$cmd" | grep -qE '(^|[;&|)( ]|&&)[[:space:]]*git([[:space:]]+-[^[:space:]]+|[[:space:]]+-C[[:space:]]+[^[:space:]]+)*[[:space:]]+push([[:space:]]|$)'; then
  echo "BLOCKED by no-push law (~/.ai/memory/laws.md): commits only, never push to a remote. If this is a sanctioned one-off, the user must run the push themselves (e.g. type '! git push ...')." >&2
  exit 2
fi

exit 0
