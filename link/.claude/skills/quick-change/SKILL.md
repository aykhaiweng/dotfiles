---
name: quick-change
description: "Make one small, well-understood change test-first through a subagent (implementer by default), verify it, and optionally commit, push and deploy it. Flags: --commit, --push, --deploy, --agent <type>, --background. Always works in the current tree and branch, never a worktree. Use when the user invokes /quick-change or asks for a quick change with any of these flags. Smaller than /one-shot (a spec or plan step built unattended); anything needing a design call, a refactor, a migration or security-sensitive work takes the normal Plan and Impact flow instead."
argument-hint: "<the change> [--commit] [--push] [--deploy] [--agent <type>] [--background]"
---

# Quick change

Make `$ARGUMENTS` (the change, plus any flags) test-first and carry it as far as the flags say.

Read `~/.claude/skills/shared/tdd.md` (the test-driven loop) and `~/.claude/skills/shared/ship.md` (commit, push,
deploy, background) before step 2.

**Always in this tree and branch.** The change is made, verified and committed in the current working tree, on the
branch it is on, `main` and the other protected branches included: never branch first. On a protected branch,
`--commit` commits there and `--push` is skipped: say that the owner pushes it (git-workflow law, quick-change
exception), and give the push command as a `! git push` line. Never spawn a worktree: no `EnterWorktree`, no `isolation: "worktree"` on the subagent, and none for
`--background` either. A `--worktree` in the arguments is not a flag here: say so and work in this tree.

## Flags

| Flag | Does | Needs |
|---|---|---|
| (none) | The change, verified, left uncommitted | |
| `--commit` | Commits the change once it is verified | |
| `--push` | Pushes after the commit | implies `--commit` |
| `--deploy` | Deploys the committed change to this workspace's development deployment | implies `--commit` |
| `--agent <type>` | Which subagent makes the change | default `implementer` |
| `--background` | Steps 2 onward run as one background agent; this session is free at once | |

Each step runs only when the one before it succeeded. A failed check stops everything after it.

## 1. Is it quick?

Read just enough to place the change: the files it touches, their tests, the commands that verify them. Then say, in
one line each, **Plan** (files, what changes, and the test list: the rule names the tests will pin) and **Impact**
(or "none"), and carry on in the same turn.

Stop and say why instead, suggesting the normal flow, when the change:
- touches auth, tokens, sessions, row-level security, reach, invites, OAuth or existence-leak answers;
- needs a migration, a new public interface (API, schema, CLI) or a package install;
- spans more than a handful of files, or needs a design decision the request does not settle.

## 2. Make it

Hand it to the subagent (`--agent`, default `implementer`) with a complete brief: the files, the exact change, the
test list, the test paths, and the commands to run. Tell it to follow the RED then GREEN steps of `shared/tdd.md`
(failing output first, then the code with the tests read-only), to not commit, push or deploy, to touch only those
files, and to report the change, the `RED:` and `Assumed:` lines and the check output. Without `--agent`, the
subagent is always `implementer`, even for a typo-sized change. A change with no behaviour to pin (a typo in a
comment, a doc line) says so in the Plan and skips RED.

`--background`: as `shared/ship.md` says, with steps 2 to 6 of this skill as the work handed over, in this tree (the
background agent gets no worktree).

## 3. Verify

Run the checks yourself; don't take the subagent's word for them. Use the repo's own commands (its docs, CLAUDE.md or
package scripts): the typecheck and lint, and the tests of what changed. Loop until they pass.
- The report has a `RED:` line that shows the new tests failing, unless the Plan said RED was skipped.
- The test diff check in `shared/tdd.md` is clean, or each test change after RED is explained.
- Read `Assumed:`. Fix any assumption that contradicts the request, the code next to it or a law; list the rest in the
  reply.

Report the commands and their counts.

## 4–6. `--commit`, `--push`, `--deploy`

As `shared/ship.md` says.

## Reply

What changed (`file:line`), the RED and verify commands with their counts, the assumptions the builder made, then
the commit (short sha and subject), the push, and the deploy with its rollback, each only if its flag was set. With `--background`, this reply comes when the agent reports; at
launch, only the Plan, Impact and "running" line. Say plainly what was skipped and why.
