#!/usr/bin/env bash
# Emits the per-project notes directory for the current pwd.
# Encoding mirrors Claude Code's per-project convention: / . _ all become -.
encoded="$(pwd | sed 's|[/._]|-|g')"
echo "$HOME/.claude/projects/${encoded}/notes"
