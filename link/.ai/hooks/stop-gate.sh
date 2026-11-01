#!/bin/bash
# Stop hook: keep the turn going while the project's fast check is red, so "done" means green.
# Opt-in per project. The project's .claude/settings.json runs it with the check as its argument:
#   "command": "~/.ai/hooks/stop-gate.sh 'npm run typecheck && npm test'"
# so the command comes from settings Claude Code already asks you to trust, not from a file
# any cloned repo could plant.
# The check runs only when the working tree differs from HEAD and from the last green run, so
# chat-only turns cost nothing. After STOP_GATE_CAP red runs in a row (default 3) it lets the turn
# end and says why: a check that can never pass (a database down, a missing secret) must not loop.
# Claude Code's own cap (8 continuations) resets on every tool call, so it never trips here.
set -u

check=${1:-}
[[ -z "$check" ]] && exit 0

input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
session=$(jq -r '.session_id // "nosession"' <<<"$input")
[[ -n "$cwd" ]] || exit 0
root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

cap=${STOP_GATE_CAP:-3}
state_dir=${STOP_GATE_STATE_DIR:-${TMPDIR:-/tmp}/stop-gate}
mkdir -p "$state_dir"
repo_key=$(printf '%s' "$root" | shasum | cut -c1-16)
session_key=$(printf '%s' "$session" | tr -c 'A-Za-z0-9_-' '_')
green_file="$state_dir/green-$repo_key"
red_file="$state_dir/red-$repo_key-$session_key"

# Fingerprint the whole working tree, untracked files included (.gitignore respected), by
# staging it into a throwaway copy of the index. The real index is never touched.
# Worktrees nested in the repo (.claude/worktrees/...) are left out, or they'd always look changed.
# One already gitignored needs no exclude, and naming it makes `git add` fail outright.
excludes=()
while IFS= read -r line; do
  [[ "$line" == worktree\ "$root"/* ]] || continue
  rel=${line#worktree "$root"/}
  git check-ignore -q "$rel" || excludes+=(":(exclude)$rel")
done < <(git worktree list --porcelain)
tmp_index=$(mktemp "$state_dir/index.XXXXXX")
trap 'rm -f "$tmp_index"' EXIT
cp "$(git rev-parse --git-path index)" "$tmp_index" 2>/dev/null || true
tree=$(GIT_INDEX_FILE=$tmp_index git add -A -- . ${excludes[@]+"${excludes[@]}"} >/dev/null 2>&1 &&
  GIT_INDEX_FILE=$tmp_index git write-tree) || exit 0
head_tree=$(git rev-parse -q --verify 'HEAD^{tree}' 2>/dev/null || true)

[[ "$tree" == "$head_tree" ]] && exit 0
[[ -f "$green_file" && "$(<"$green_file")" == "$tree" ]] && exit 0

out=$(bash -c "$check" 2>&1)
status=$?

if (( status == 0 )); then
  printf '%s' "$tree" >"$green_file"
  rm -f "$red_file"
  exit 0
fi

reds=$(( $(cat "$red_file" 2>/dev/null || echo 0) + 1 ))
if (( reds >= cap )); then
  rm -f "$red_file"
  jq -n --arg m "Stop gate: '$check' is still red after $reds runs in a row; letting the turn end. Fix it by hand or say how to proceed." '{systemMessage: $m}'
  exit 0
fi
printf '%s' "$reds" >"$red_file"

{
  echo "Stop gate: '$check' failed (exit $status, red run $reds of $cap). Fix it before finishing; never skip or weaken a test to go green. Last 80 lines:"
  tail -n 80 <<<"$out"
} >&2
exit 2
