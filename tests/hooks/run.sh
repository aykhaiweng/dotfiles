#!/bin/bash
# Tests for link/.ai/hooks: each case feeds a hook the JSON Claude Code would send on stdin and
# checks its exit code and output. Run: tests/hooks/run.sh
set -u

here=$(cd "$(dirname "$0")" && pwd -P)
hooks="$here/../../link/.ai/hooks"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
work=$(cd "$work" && pwd -P)
pass=0 fail=0

# expect <name> <want exit> <want substring in stderr+stdout, or ""> <hook> [args...] <<<json
expect() {
  local name=$1 want=$2 grep=$3 out code
  shift 3
  out=$("$@" 2>&1)
  code=$?
  if [[ $code == "$want" && ( -z "$grep" || "$out" == *"$grep"* ) ]]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    printf 'FAIL %s: exit %s (want %s)\n%s\n' "$name" "$code" "$want" "$out"
  fi
}
json() { jq -n --arg cwd "$1" --arg f "${2:-}" --arg s "${3:-s1}" '{session_id:$s, cwd:$cwd, tool_input:{file_path:$f}}'; }
# ok <name> <test command...>: count a plain condition as a pass or a failure
ok() { local name=$1; shift; if "$@"; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL $name"; fi; }

repo="$work/repo"
git init -q "$repo"
git -C "$repo" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init
echo x >"$repo/tracked" && git -C "$repo" add tracked
git -C "$repo" -c user.email=t@t -c user.name=t commit -q -m tracked

# --- worktree-guard -----------------------------------------------------------------------------
guard="$hooks/worktree-guard.sh"
wt="$repo/.claude/worktrees/wt-a"
git -C "$repo" worktree add -q "$wt" -b wt-a
sib="$work/sibling"
git -C "$repo" worktree add -q "$sib" -b wt-b

expect "guard: write inside own worktree is allowed" 0 "" "$guard" <<<"$(json "$wt" "$wt/src/new/file.ts")"
expect "guard: write into the main checkout is denied" 2 "another checkout" "$guard" <<<"$(json "$wt" "$repo/tracked")"
expect "guard: write into a sibling worktree is denied" 2 "another checkout" "$guard" <<<"$(json "$wt" "$sib/tracked")"
expect "guard: .. that climbs out of the worktree is denied" 2 "another checkout" "$guard" <<<"$(json "$wt" "$wt/nope/../../../../tracked")"
expect "guard: path outside the repository is allowed" 0 "" "$guard" <<<"$(json "$wt" "$work/elsewhere/x")"
expect "guard: the main checkout itself is never restricted" 0 "" "$guard" <<<"$(json "$repo" "$sib/tracked")"
expect "guard: a cwd outside git is ignored" 0 "" "$guard" <<<"$(json "$work" "$repo/tracked")"
expect "guard: a tool without file_path is ignored" 0 "" "$guard" <<<"$(json "$wt" "")"
ln -s "$repo" "$work/link-to-main"
expect "guard: a symlink into the main checkout is denied" 2 "another checkout" "$guard" <<<"$(json "$wt" "$work/link-to-main/tracked")"
expect "guard: a * in a name is not globbed" 0 "" "$guard" <<<"$(json "$wt" "$wt/*/x")"

# --- stop-gate ----------------------------------------------------------------------------------
gate="$hooks/stop-gate.sh"
export STOP_GATE_STATE_DIR="$work/state"
runs="$work/runs" # every run of the check appends a line here
check="echo run >>'$runs'; test -f ok"
count() { [[ -f "$runs" ]] && wc -l <"$runs" | tr -d ' ' || echo 0; }

expect "gate: no check argument does nothing" 0 "" "$gate" <<<"$(json "$repo")"
expect "gate: a clean tree skips the check" 0 "" "$gate" "$check" <<<"$(json "$repo")"
ok "gate: a clean tree never runs the check" [ "$(count)" = 0 ]

echo dirty >>"$repo/tracked"
expect "gate: a red check on a changed tree blocks the turn" 2 "red run 1 of 3" "$gate" "$check" <<<"$(json "$repo")"
expect "gate: the check's output is fed back" 2 "Last 80 lines" "$gate" "$check" <<<"$(json "$repo")"
expect "gate: the third red run in a row lets the turn end" 0 "still red after 3 runs" "$gate" "$check" <<<"$(json "$repo")"
expect "gate: after the cap the count starts again" 2 "red run 1 of 3" "$gate" "$check" <<<"$(json "$repo")"
expect "gate: red counts are per session" 2 "red run 1 of 3" "$gate" "$check" <<<"$(json "$repo" "" s2)"

touch "$repo/ok" # untracked, so it changes the tree fingerprint too
expect "gate: a green check lets the turn end" 0 "" "$gate" "$check" <<<"$(json "$repo")"
before=$(count)
expect "gate: an unchanged green tree skips the check" 0 "" "$gate" "$check" <<<"$(json "$repo")"
ok "gate: an unchanged green tree never re-runs the check" [ "$(count)" = "$before" ]
ok "gate: the real index is never changed" [ -z "$(git -C "$repo" diff --cached --name-only)" ]
expect "gate: a cwd outside git does nothing" 0 "" "$gate" "$check" <<<"$(json "$work")"

# A gitignored nested worktree (namine ignores .worktrees/) must not stop the gate from running.
ign="$work/ign"
git init -q "$ign"
echo ".worktrees/" >"$ign/.gitignore" && git -C "$ign" add .gitignore
git -C "$ign" -c user.email=t@t -c user.name=t commit -q -m init
git -C "$ign" worktree add -q "$ign/.worktrees/wt-c" -b wt-c
expect "gate: a clean tree with an ignored nested worktree skips the check" 0 "" "$gate" "false" <<<"$(json "$ign" "" s3)"
echo change >"$ign/new-file"
expect "gate: an ignored nested worktree doesn't hide a red check" 2 "red run 1 of 3" "$gate" "false" <<<"$(json "$ign" "" s3)"

echo "$pass passed, $fail failed"
((fail == 0))
