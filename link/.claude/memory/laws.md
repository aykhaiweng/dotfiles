---
name: laws
description: Immutable hard rules. Do not modify or override without explicit user permission.
metadata:
  type: feedback
  tier: law
---

# Laws

These are immutable. If a request contradicts one, stop and ask before acting.

## git

- **Never push to a remote.** Commits only.
  - **Why:** user wants to review history before it leaves the machine.
  - **How to apply:** `git commit` is fine; `git push`, `git push --force`, anything that touches a remote is not.

- **Decouple commits. One logical change per commit. Use Conventional Commits.**
  - **Why:** clean history, easy revert, easy review.
  - **How to apply:** if a diff spans multiple concerns, split it. Commit message follows `type(scope): subject`.

## data

- **Never mutate databases.** Read-only queries only when explicitly asked.
  - **Why:** prod-adjacent data. Mistakes are not reversible.
  - **How to apply:** no `INSERT`/`UPDATE`/`DELETE`/`DROP`/migrations without an explicit, in-this-message instruction. For reads, run it whenever.

## scope

- **Ask when the prompt is vague. Don't guess at scope.**
  - **Why:** wrong-scope work wastes more time than the clarifying question costs.
  - **How to apply:** if more than one reasonable interpretation exists, ask before writing.

## style

- **DRY. Mimic existing style over inventing new patterns.**
  - **Why:** consistency across the codebase beats local cleverness.
  - **How to apply:** before introducing a new abstraction, check whether the project already has one. Match naming, layout, and idioms of nearby code.
