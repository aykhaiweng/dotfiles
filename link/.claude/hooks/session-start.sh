#!/usr/bin/env bash
# Surface per-project notes at session start so Claude knows to read them.
# Output goes to stdout, which Claude Code injects as additional context.

NOTES_DIR="$HOME/.claude/projects/$(pwd | sed 's|[/._]|-|g')/notes"
[ -d "$NOTES_DIR" ] || exit 0

found=()
for f in worklog.md map.md gotchas.md; do
  [ -s "$NOTES_DIR/$f" ] && found+=("$f")
done

[ ${#found[@]} -eq 0 ] && exit 0

echo "📓 Project notes exist at $NOTES_DIR:"
for f in "${found[@]}"; do
  lines=$(wc -l < "$NOTES_DIR/$f")
  echo "  - $f ($lines lines)"
done
echo ""
echo "Read these before substantive work. Use the matching agent (repo-mapper, worklog, gotchas) to query or update."
