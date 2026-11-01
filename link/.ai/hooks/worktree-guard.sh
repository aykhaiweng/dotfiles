#!/bin/bash
# PreToolUse hook for file tools: an agent working in a git worktree may not write into another
# checkout of the same repository (the main checkout or a sibling worktree). Agents leak there
# through an absolute path remembered from earlier or a `cd` that didn't persist between calls.
# Paths outside the repository (the scratchpad, /tmp, other repos) stay allowed.
# Not covered: writes made through Bash, whose paths can't be parsed reliably.
set -u

input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
file=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' <<<"$input")
[[ -n "$cwd" && -n "$file" && "$file" == /* ]] || exit 0

git_dir=$(git -C "$cwd" rev-parse --absolute-git-dir 2>/dev/null) || exit 0
common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0
git_dir=$(cd "$git_dir" && pwd -P); common=$(cd "$common" && pwd -P)
[[ "$git_dir" == "$common" ]] && exit 0 # the main checkout, not a worktree

# Collapse . and .. without touching the disk, then resolve symlinks on the part that exists.
normalise() {
  local part parts=() out=()
  IFS=/ read -r -a parts <<<"$1" # read -a, not a bare $1, so a * in a name is never globbed
  for part in ${parts[@]+"${parts[@]}"}; do
    case $part in
      '' | .) ;;
      ..) ((${#out[@]})) && unset 'out[${#out[@]}-1]' ;;
      *) out+=("$part") ;;
    esac
  done
  printf '/%s' ${out[@]+"${out[@]}"}
}
physical() {
  local p rest=""
  p=$(normalise "$1")
  while [[ ! -d "$p" && "$p" != / ]]; do rest="/${p##*/}$rest"; p=${p%/*}; p=${p:-/}; done
  p=$(cd "$p" && pwd -P)
  printf '%s%s' "${p%/}" "$rest"
}
under() { [[ "$1" == "$2" || "$1" == "$2"/* ]]; }

target=$(physical "$file")
own=$(physical "$(git -C "$cwd" rev-parse --show-toplevel)")
under "$target" "$own" && exit 0

while IFS= read -r line; do
  [[ "$line" == worktree\ * ]] || continue
  tree=$(physical "${line#worktree }")
  if under "$target" "$tree"; then
    echo "Worktree guard: $file is in another checkout of this repository ($tree), not this worktree ($own). Write to the same path under $own instead." >&2
    exit 2
  fi
done < <(git -C "$cwd" worktree list --porcelain)
exit 0
