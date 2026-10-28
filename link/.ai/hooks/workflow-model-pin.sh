#!/bin/bash
# PreToolUse hook for Workflow: refuse a script that spawns agents without naming a model.
# Stopgap for the orchestration-policy model tiers until Naminé can guard non-shell tools
# (thread explore-tool-guards-beyond-shell-and-write). An unpinned agent() inherits the
# session's Opus, so builders meant for Sonnet run at Opus cost.
# Coarse on purpose: it denies only when the script has agent( calls and no model: at all,
# so shared option objects (const BUILD = { model: 'sonnet', ... }) pass.

input=$(cat)

script=$(jq -r '.tool_input.script // empty' <<<"$input")
if [[ -z "$script" ]]; then
  path=$(jq -r '.tool_input.scriptPath // empty' <<<"$input")
  # A saved workflow (tool_input.name) or an unreadable path: nothing to check.
  [[ -n "$path" && -r "$path" ]] && script=$(<"$path")
fi

[[ -z "$script" ]] && exit 0
[[ "$script" =~ agent\( ]] || exit 0
[[ "$script" =~ model[\"\']?[[:space:]]*: ]] && exit 0

echo "Workflow refused: agent() calls name no model, so they inherit Opus. Pass a tier on every call per orchestration-policy: builders { model: 'sonnet', effort: 'medium' }, planning/review/verify { model: 'opus', effort: 'high' }, sweeps { model: 'haiku' | 'sonnet', effort: 'medium' }." >&2
exit 2
