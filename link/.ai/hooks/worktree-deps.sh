#!/usr/bin/env bash
# SessionStart / CwdChanged hook: a fresh linked git worktree of a pnpm repo has no node_modules and no built
# packages, so the Stop gate's type check fails on missing modules. Install from the lockfile and build once.
# Main checkouts and worktrees whose install and build already succeeded are left alone. Never blocks the session.
set -uo pipefail

input=$(cat)
dir=$(printf '%s' "$input" | jq -r '.new_cwd // .cwd // empty' 2>/dev/null)
[ -n "$dir" ] || dir=$PWD
event=$(printf '%s' "$input" | jq -r '.hook_event_name // empty' 2>/dev/null)

top=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || exit 0
git_dir=$(git -C "$top" rev-parse --absolute-git-dir 2>/dev/null) || exit 0
common_dir=$(git -C "$top" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0
# Only linked worktrees: in the main checkout the two are the same directory.
[ "$git_dir" != "$common_dir" ] || exit 0
[ -f "$top/pnpm-lock.yaml" ] || exit 0
# The stamps live in the worktree's own git dir, so they never show in the tree. `node_modules` alone is no proof:
# an interrupted install or a failed build leaves it behind, and the gate then fails on missing modules again.
ok="$git_dir/worktree-deps.ok"
failed="$git_dir/worktree-deps.failed"
[ -f "$ok" ] && exit 0
# After a failure only SessionStart retries, so a build that keeps failing does not stall every cd.
[ -f "$failed" ] && [ "$event" = "CwdChanged" ] && exit 0

log="${TMPDIR:-/tmp}/worktree-deps-$(basename "$top").log"
say() { jq -cn --arg m "$1" '{systemMessage: $m}'; }
fail() { date -u +%FT%TZ >"$failed"; say "$1"; exit 0; }

cd "$top" || exit 0
pnpm install --frozen-lockfile >"$log" 2>&1 || fail "worktree-deps: pnpm install failed in $top (log: $log)"
if jq -e '.scripts.build' package.json >/dev/null 2>&1; then
  pnpm run build >>"$log" 2>&1 || fail "worktree-deps: installed, but the build failed in $top (log: $log)"
fi
rm -f "$failed"
date -u +%FT%TZ >"$ok"
say "worktree-deps: installed and built $top"
exit 0
