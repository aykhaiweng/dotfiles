#!/usr/bin/env bash
# SessionStart / CwdChanged hook: a fresh linked git worktree of a pnpm repo has no node_modules and no built
# packages, so the Stop gate's type check fails on missing modules. Install from the lockfile and build once.
# Main checkouts and worktrees that already have node_modules are left alone. Never blocks the session.
set -uo pipefail

input=$(cat)
dir=$(printf '%s' "$input" | jq -r '.new_cwd // .cwd // empty' 2>/dev/null)
[ -n "$dir" ] || dir=$PWD

top=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || exit 0
git_dir=$(git -C "$top" rev-parse --absolute-git-dir 2>/dev/null) || exit 0
common_dir=$(git -C "$top" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0
# Only linked worktrees: in the main checkout the two are the same directory.
[ "$git_dir" != "$common_dir" ] || exit 0
[ -f "$top/pnpm-lock.yaml" ] || exit 0
[ -d "$top/node_modules" ] && exit 0

log="${TMPDIR:-/tmp}/worktree-deps-$(basename "$top").log"
say() { jq -cn --arg m "$1" '{systemMessage: $m}'; }

cd "$top" || exit 0
if ! pnpm install --frozen-lockfile >"$log" 2>&1; then
  say "worktree-deps: pnpm install failed in $top (log: $log)"
  exit 0
fi
if jq -e '.scripts.build' package.json >/dev/null 2>&1 && ! pnpm run build >>"$log" 2>&1; then
  say "worktree-deps: installed, but the build failed in $top (log: $log)"
  exit 0
fi
say "worktree-deps: installed and built $top"
exit 0
