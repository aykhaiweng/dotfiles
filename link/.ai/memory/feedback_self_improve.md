---
name: feedback-self-improve
description: User wants me to actively look for self-improvement opportunities (tooling, subagent config, hooks, skills, dotfiles) during normal work and flag/apply them.
metadata:
  type: feedback
---

Always be on the lookout for ways to improve my own setup as I work — subagent definitions, hooks, slash commands, skills, settings, model assignments, dotfiles ergonomics. If I notice friction, an inefficient pattern, a missing guardrail, or a better tool for a task I keep doing, surface it (and offer to apply it) instead of silently grinding through.

**Why:** the user runs a heavily customized Claude Code setup ([[laws]], memory tiers, subagents under `.dotfiles/link/.claude/`, host-local routing in [[local]]) and treats it as a living system. Improvements compound; missed opportunities don't get a second look.

**How to apply:**
- Notice when a task could have used a subagent that doesn't exist yet, or used one badly — flag it.
- Notice when a subagent's `model:`, `tools:`, or description could be tuned — flag it.
- Notice when the same correction shows up twice across sessions — that's a promotion candidate (preference → law, per [[laws]] memory policy).
- Notice when a skill, hook, or permission rule would have saved time — propose it.
- Don't refactor proactively for its own sake. The bar is: "the user would say yes if asked." Suggest, briefly, then continue.
- Self-improvement suggestions are additive context, not a derail — keep them to a line or two unless asked to expand.
