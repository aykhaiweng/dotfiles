#!/bin/bash
# SessionStart / UserPromptSubmit hook: title the session "<repo> · <branch>" so sessions are
# findable by where they ran. <repo> is the main checkout's directory, also inside a worktree.
# Outside git, print nothing and Claude Code keeps its own title.
# Runs on every prompt so the title follows a branch switch or EnterWorktree mid-session.
set -u

input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
[[ -n "$event" && -n "$cwd" ]] || exit 0

common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0
# Bare repos and odd layouts: fall back to the toplevel's name.
if [[ "$(basename "$common")" == ".git" ]]; then
  repo=$(basename "$(dirname "$common")")
else
  repo=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || echo "$common")")
fi

branch=$(git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null) \
  || branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null) \
  || branch="(no commits)"

jq -nc --arg e "$event" --arg t "$repo · $branch" \
  '{hookSpecificOutput: {hookEventName: $e, sessionTitle: $t}}'
