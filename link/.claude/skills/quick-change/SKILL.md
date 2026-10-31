---
name: quick-change
description: "Make one small, well-understood change through a subagent (implementer by default), verify it, and optionally commit, push and deploy it. Flags: --commit, --push, --deploy, --agent <type>, --worktree, --background. Use when the user invokes /quick-change or asks for a quick change with any of these flags. Not for refactors, migrations, security-sensitive or design work: those take the normal Plan and Impact flow."
argument-hint: "<the change> [--commit] [--push] [--deploy] [--agent <type>] [--worktree] [--background]"
---

# Quick change

Make `$ARGUMENTS` (the change, plus any flags) and carry it as far as the flags say.

## Flags

| Flag | Does | Needs |
|---|---|---|
| (none) | The change, verified, left uncommitted | |
| `--commit` | Commits the change once it is verified | |
| `--push` | Pushes after the commit | implies `--commit` |
| `--deploy` | Deploys the committed change to this workspace's development deployment | implies `--commit` |
| `--agent <type>` | Which subagent makes the change | default `implementer` |
| `--worktree` | The change is made, verified and committed in a fresh git worktree, not the current tree | |
| `--background` | Steps 2 onward run as one background agent; this session is free at once | |

Each step runs only when the one before it succeeded. A failed check stops everything after it: never commit, push or
deploy what did not verify.

## 1. Is it quick?

Read just enough to place the change: the files it touches, their tests, the commands that verify them. Then say, in
one line each, **Plan** (files and what changes) and **Impact** (or "none"), and carry on in the same turn.

Stop and say why instead, suggesting the normal flow, when the change:
- touches auth, tokens, sessions, row-level security, reach, invites, OAuth or existence-leak answers;
- needs a migration, a new public interface (API, schema, CLI) or a package install;
- spans more than a handful of files, or needs a design decision the request does not settle;
- is on main, master, dev or staging and `--commit` is set (branch first, or ask).

## 2. Make it

Hand it to the subagent (`--agent`, default `implementer`) with a complete brief: the files, the exact change, the
test to add or adjust so it pins the rule, and the commands to run. Tell it to not commit, push or deploy, to touch
only those files, and to report what it changed and the check output. Without `--agent`, the subagent is always `implementer`, even for a typo-sized change.

With `--worktree`, spawn the subagent with `isolation: "worktree"` (always a subagent, never a direct edit). It branches
from the current `HEAD` and gets its own path. Steps 3 to 6 then run in that worktree: verify there, commit on its
branch, push that branch, and deploy builds from its `HEAD`. The current tree and branch are never touched. Leave the
worktree in place and report its path and branch; merging it back is the user's call.

## `--background`

Do step 1 in this session (Plan, Impact and the "is it quick?" stop), then hand steps 2 to 6 to one background agent
(`run_in_background: true`, the `--agent` type, else `implementer`) and say in one line that it is running. Give it this skill's steps 2 to
6 and the Reply section, the flags, the brief, and the attribution lines. It verifies and commits itself, since nobody
is watching. It cannot ask the user, so it stops and reports wherever this skill would ask: a deploy with a migration,
an unclear failure, or a change that turns out not to be quick. When it reports, check its verify counts and commit
before relaying them; don't take them on its word. `--background` combines with `--worktree`, which is the safer
choice when other work is going on in the same tree.

## 3. Verify

Run the checks yourself; don't take the subagent's word for them. Use the repo's own commands (its docs, CLAUDE.md or
package scripts): the typecheck and lint, and the tests of what changed. Loop until they pass. Never skip, delete or
weaken a test to go green. Report the commands and their counts.

## 4. `--commit`

- Commit only this change's files, never `git add -A`: other sessions may have uncommitted work in the same tree.
  Mention anything else uncommitted rather than touching it.
- A Conventional Commit, `type(scope): subject` with a 2-4 line body (what, why, the alternative rejected), ending
  with the attribution lines this session was given.

## 5. `--push`

`git push -u origin HEAD` only. Never force, never a protected branch. If the branch has an open PR whose description
lists the work, say so in one line and offer to update it.

## 6. `--deploy`

Deploy the way this workspace already does, and only to its development or throwaway deployment:
- Find the recipe: a project skill, `docs/development.md` or a deploy doc, the repo's scripts, or a Naminé note (a
  hand-off note's "Deploy recipe"). In a git worktree, use the deployment that worktree runs on (for example a local
  container on a dev port). No recipe found, or only production: stop and say so.
- Build from the committed HEAD (e.g. `git archive HEAD | docker build -`), so uncommitted work never ships.
- Keep a way back first, as the recipe does it (a rollback image tag, a database dump).
- A database migration in the deploy needs the user's explicit go in that message: ask instead of deploying.
- Afterwards, check it is up (the health endpoint, the routes the change touched) and report the rollback tag.

## Reply

What changed (`file:line`), the verify commands and their counts, then the commit (short sha and subject), the push,
and the deploy with its rollback, each only if its flag was set. With `--worktree`, the worktree's path and branch.
With `--background`, this reply comes when the agent reports; at launch, only the Plan, Impact and "running" line. Say
plainly what was skipped and why.
