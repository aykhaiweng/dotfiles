#!/bin/bash
# Tests for bin/claude-settings-merge: each case builds settings.json in a scratch dir and checks
# the result. Run: tests/claude-settings/run.sh
set -u

here=$(cd "$(dirname "$0")" && pwd -P)
merge="$here/../../bin/claude-settings-merge"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
pass=0 fail=0
ok() { local name=$1; shift; if "$@"; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL $name"; fi; }
get() { jq -r "$1" "$d/settings.json"; }

fresh() {
  d="$work/$1"; mkdir -p "$d"
  echo '{"model":"opus","permissions":{"allow":["a"]},"hooks":{"x":"$HOME/h.sh"}}' >"$d/settings.base.json"
  echo '{"model":"sonnet","permissions":{"additionalDirectories":["/m"]}}' >"$d/settings.machine.json"
}

# The machine file wins on conflicts, objects merge key by key, and $HOME is substituted.
fresh merge; HOME=/home/t "$merge" "$d" >/dev/null
ok "machine file overrides the base" test "$(get .model)" = sonnet
ok "objects merge rather than replace" test "$(get '.permissions | keys | join(",")')" = "additionalDirectories,allow"
ok "\$HOME in the base becomes this machine's home" test "$(get .hooks.x)" = /home/t/h.sh

# A setting Claude Code saved since the last build must not be silently overwritten.
fresh drift; "$merge" "$d" >/dev/null
jq '.theme = "dark"' "$d/settings.json" >"$d/t" && mv "$d/t" "$d/settings.json"
"$merge" "$d" >/dev/null 2>&1; code=$?
ok "drift since the last build stops the merge" test "$code" = 1
ok "drift leaves settings.json untouched" test "$(get .theme)" = dark
CLAUDE_SETTINGS_FORCE=1 "$merge" "$d" >/dev/null
ok "CLAUDE_SETTINGS_FORCE drops the drift" test "$(get .theme)" = null

# First run on a machine (no snapshot): a pre-existing file that differs is protected too.
fresh first; echo '{"theme":"light"}' >"$d/settings.json"
"$merge" "$d" >/dev/null 2>&1; code=$?
ok "an unknown existing settings.json is protected" test "$code" = 1

# Rebuilding after an edit to the base is fine: the live file still matches the last build.
fresh rebuild; "$merge" "$d" >/dev/null
echo '{"model":"haiku"}' >"$d/settings.base.json"; rm "$d/settings.machine.json"
"$merge" "$d" >/dev/null; code=$?
ok "a base edit rebuilds without the machine file" test "$code:$(get .model)" = 0:haiku

echo "$pass passed, $fail failed"
[[ $fail == 0 ]]
