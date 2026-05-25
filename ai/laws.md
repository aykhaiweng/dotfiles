<!-- markdownlint-disable MD041 -->

- **Never push to a remote.** Commits only. Use `git commit`; never `git push`.
  - **Why:** user wants to review history before it leaves the machine.
  - **How to apply:** `git commit` is fine; `git push`, `git push --force`,
    anything that touches a remote is not.

- **Decouple commits. One logical change per commit. Use Conventional Commits.**
  - **Why:** clean history, easy revert, easy review.
  - **How to apply:** if a diff spans multiple concerns, split it. Commit
    message follows `type(scope): subject`.

- **Never mutate databases.** Read-only queries only. No
  `INSERT/UPDATE/DELETE/migrations` without explicit instruction.
  - **Why:** prod-adjacent data. Mistakes are not reversible.
  - **How to apply:** no `INSERT`/`UPDATE`/`DELETE`/`DROP`/migrations without
    an explicit, in-this-message instruction. For reads, run it whenever.

- **Ask when the prompt is vague. Don't guess at scope.**
  - **Why:** wrong-scope work wastes more time than the clarifying question
    costs.
  - **How to apply:** if more than one reasonable interpretation exists, ask
    before writing.

- **DRY. Mimic existing style over inventing new patterns.**
  - **Why:** consistency across the codebase beats local cleverness.
  - **How to apply:** before introducing a new abstraction, check whether the
    project already has one. Match naming, layout, and idioms of nearby code.
