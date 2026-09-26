<!-- markdownlint-disable MD041 -->

### Ask when the prompt is vague. Don't guess at scope

- **How to apply:** if more than one reasonable interpretation exists, ask
  before writing.

Why: wrong-scope work wastes more time than the clarifying question costs.

### Decouple commits. One logical change per commit. Use Conventional Commits

- **How to apply:** if a diff spans multiple concerns, split it. Commit
  message follows `type(scope): subject`.

Why: clean history, easy revert, easy review.

### DRY. Mimic existing style over inventing new patterns

- **How to apply:** before introducing a new abstraction, check whether the
  project already has one. Match naming, layout, and idioms of nearby code.

Why: consistency across the codebase beats local cleverness.

### Never mutate databases

Read-only queries only. No
`INSERT/UPDATE/DELETE/migrations` without explicit instruction.
- **How to apply:** no `INSERT`/`UPDATE`/`DELETE`/`DROP`/migrations without
  an explicit, in-this-message instruction. For reads, run it whenever.

Why: prod-adjacent data. Mistakes are not reversible.

### Never push to a remote

Commits only. Use `git commit`; never `git push`.
- **How to apply:** `git commit` is fine; `git push`, `git push --force`,
  anything that touches a remote is not.

Why: user wants to review history before it leaves the machine.
