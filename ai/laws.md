<!-- markdownlint-disable MD041 -->

### 'Think, then show the Plan and Impact before every change'

Before changing any code, config, docs or other files, show the Plan and Impact first, however small the change.

- **Orient first:** read the code, spec or plan step, and before adding code, the callers, exports and shared utilities it touches. Orientation is not a change; writing is.
- **Assumptions:** state them. When a request has more than one reasonable reading or leaves an architectural gap, ask 1–2 questions, each with a recommended default. When confused, name what is unclear instead of guessing. If a simpler approach exists, say so before building.
- **Plan:** every file to create, modify or delete, and the logic, data-flow or structural change in each. For an approved plan or spec, point to the step and spell out only what differs.
- **Impact:** only what applies: breaking changes (features, APIs, schemas), performance and security, tech debt and coupling, edge cases left out on purpose. One line covers the rest.
- **Confirmation:** architectural shifts, multi-file refactors and destructive changes stop after Plan and Impact for approval; small isolated changes go ahead in the same turn.
- **Skeleton first:** a new module or public interface (API, schema, CLI) also stops after its skeleton (data model, interfaces, empty signatures with docstrings) for review.
- **Scale:** a typo or one-line fix gets one line each ("Plan: fix typo in `x.ts:12`. Impact: none.").
- **Side effects:** flag in **bold** any package install, build-config or environment-variable change.
- **Intent comments:** a brief why-comment above non-obvious logic, at the surrounding code's comment density.

Why: Wrong assumptions found before the code lands cost a sentence and after it a rewrite, and seeing files, logic and consequences up front lets the user steer at the level of intent without reading every diff.

### 'Git workflow: feature branches, decoupled commits, draft PRs'

Once the Plan is approved, an agent works on a feature branch through to a draft PR without asking per commit, and never commits to, pushes to or merges into main, master, dev or staging. Exception: the dotfiles repo, below.
- **How to apply:**
  - **Branch:** from a protected branch, create `type/slug` first, the type a Conventional Commit type (e.g. `feat/invoice-export`).
  - **Commits:** one logical change each, after each green test run with the pre-commit hook passing. `type(scope): subject` plus a 2–4 line body: what, why, and the alternatives rejected. A ticket named by the task, branch or prompt goes in a final `Refs: TICKET-ID` line, never in the scope.
  - **Push:** `git push -u origin HEAD` only. Never `--force`, `-f`, `--force-with-lease`, or a refspec naming a protected branch. Exception: `git push origin archive/<tag>` publishes an archive tag from any branch.
  - **PR:** `gh pr create --draft` against the branch the work started from, with summary, test evidence (command + result), coverage before/after, and migration or rollback notes where they apply. Report the branch, the commits (short hash + subject) and the PR link.
  - Never merge, approve or mark a PR ready (`gh pr merge`, `gh pr ready`, `gh pr review --approve`). Amend, rebase and reset need an explicit ask.
  - **Dotfiles exception:** in `/Users/aykhaiweng/.dotfiles` an agent commits straight to `main` and pushes with `git -C /Users/aykhaiweng/.dotfiles push origin HEAD`; no feature branch, no PR. Every commit and push there is written as `git -C /Users/aykhaiweng/.dotfiles …`, since that prefix is what the guard exempts. Commit rules (decoupled Conventional Commits, specific paths, no `--no-verify`) and the no-force rule still apply.
- Big or destructive changes still stop for Plan approval; that approval is where autonomy starts.

Why: Decoupled commits are easy to revert and review and a recorded rejected alternative stops it being re-proposed, while the user reviews at the draft PR and keeps protected branches and merging; guards can only allowlist branch names, hence type/slug. The archive-tag exception lets an agent preserve a snapshot before a rewrite without touching any branch. The dotfiles exception is the owner's call (2026-11-01, "change the law"); guards see only the command text and the branch, not the repo, so it is keyed on the `git -C <dotfiles path>` prefix.

### Goal-driven execution

- **How to apply:**
  - Before starting, turn the task into a goal you can check:
    - "add validation" → tests for the invalid inputs, then make them pass;
    - "fix the bug" → reproduce it in a test, then make it pass;
    - "make it faster" → measure before and after;
    - "refactor X" → tests pass before and after. If X has no tests, first write ones that capture how it behaves today.
  - For multi-step work, give a brief plan with a check for each step (it fits inside the Plan of "Show the Plan and Impact").
  - Loop until the check passes: run it, read the output, fix, run again. Don't declare done on "should work".
  - Each test pins a business rule: it must fail if that rule changes. Name it for the rule, not the function.
  - Never skip, delete or weaken a test to go green. Coverage does not decrease.
  - Report the evidence (test counts, measurements, output) and say plainly what was not verified. Never state a number, status or result you didn't get by running something: run it and report the output.

Why: A checkable goal tells you when you're done and proves it to the user, and a test weakened to go green turns that proof into a lie.

### Never mutate production databases

Read-only queries only on production databases; run reads anywhere, whenever. Local dev databases may be written without asking.
- **How to apply:**
  - **Production:** any hosted or remote database (a cloud instance, a teammate's or an organization's server, anything reached over the network rather than on this machine). No `INSERT`/`UPDATE`/`DELETE`/`DROP`/`TRUNCATE`/migrations or restores there without an explicit instruction in the current message.
  - **Local dev:** databases running on this machine: local Docker or Postgres instances, test databases (`namine_test`), `wt-<name>` worktree databases, throwaway containers, and main's local Naminé database. Writes, migrations, seeds and restores are fine; still say what you ran.
  - **When unsure** whether a database is production (an unfamiliar URL, a tunnel, a forwarded port, a connection string from someone else), treat it as production and ask.

Why: Production data is shared and mistakes there are not reversible; local dev databases are the user's own and can be rebuilt, so guarding them only slows work down (user, 2026-11-01).

### 'Simplicity first: change only what was asked, and match the code around you'

- **How to apply:**
  - Build what was asked; every changed line traces back to the request. No features, configuration or "flexibility" nobody requested, and no abstraction for a single use.
  - Of two working designs, pick the one with fewer moving parts and say why. If a senior engineer would call it overcomplicated (200 lines that could be 50), rewrite it.
  - Reuse what the project has, and match the naming, layout and idioms of nearby code even where you'd write it differently. Never create a parallel module, app or table to dodge a migration: write the migration plan and ask.
  - When two existing patterns conflict, follow one, say which and why, and flag the other. Never blend them.
  - Prefer boring, well-maintained libraries. Swapping one is an architecture decision: justify it and note what breaks.
  - Handle the errors that can happen, and security boundaries always (Security first); not the ones that can't.
  - Don't touch adjacent code, comments or formatting, or refactor what isn't broken. Mention unrelated problems; fix them only if asked. Remove only what your own change orphaned.
  - Once it works, do one refactor pass over the code you wrote this task, committed separately as `refactor`.

Why: Every extra line has to be read, tested and maintained, small consistent diffs are easy to review, revert and bisect, and a parallel copy leaves two versions to keep in sync for good.

### Worktree locations and wt- naming

Where a worktree goes depends on who makes it, and anything a worktree needs a key or name for is called `wt-<worktree name>`.

- **How to apply:**
  - **The user's worktrees** sit in `<repo>/.worktrees/<name>`. Leave them where they are; never move them.
  - **Claude's worktrees** are made with the built-in `EnterWorktree` tool (leave with `ExitWorktree`), which puts them in `<repo>/.claude/worktrees/<name>`. Never hand-roll `git worktree add .worktrees/…` or a sibling directory.
  - **Names and keys:** every name or key a worktree needs (Docker Compose project, database, image tag, container, volume, cache or data directory) is `wt-<name>`. `<name>` is the worktree's directory name, which is its branch with `/` turned into `-`. Drop Claude's `worktree-` branch prefix, so it reads `wt-foo`, not `wt-worktree-foo`.
  - Never share one of those names or keys between two worktrees, or between a worktree and main.

Why: User, 2026-11-01: worktrees from both the user and Claude, each with its own environment, need one predictable home per author and one naming scheme so nothing collides or gets cleaned up by mistake.
