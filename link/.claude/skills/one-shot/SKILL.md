---
name: one-shot
description: "Build a whole spec, plan step or large change end to end with no intervention, taking every default, and report the decisions made so the user can reverse them later. Flags: --commit, --push, --deploy, --migrate, --token-budget <n>, --workflow, --goal, --worktree, --background. Use when the user invokes /one-shot or asks to build something large unattended with all defaults (e.g. a step spec such as docs/plans/ui/step16c-spec.md). Not for small changes: those are /quick-change."
argument-hint: "<spec, plan or change> [--commit] [--push] [--deploy] [--migrate] [--token-budget <n>] [--workflow | --goal] [--worktree] [--background]"
---

# One shot

Build `$ARGUMENTS` (the target, plus any flags) from start to finish without asking, then report what was decided on the
user's behalf. The invocation is the approval: the Plan and Impact is shown, not waited on.

## Flags

| Flag | Does | Needs |
|---|---|---|
| (none) | Builds and verifies; leaves the work uncommitted, with the commit split it would make | |
| `--commit` | Commits each logical part after it goes green (decoupled Conventional Commits) | |
| `--push` | Pushes once the whole build is green | implies `--commit` |
| `--deploy` | Deploys the finished HEAD to this workspace's development deployment | implies `--commit` |
| `--migrate` | The user's go for the migrations this build adds, applied by `--deploy` (after the dump), so it never stops there | with `--deploy` |
| `--token-budget <n>` | A hard ceiling on tokens for the run (`500k`, `1.2m`, `800000`) | default: the agent's estimate |
| `--workflow` | Runs the build as a dynamic Workflow (this flag is the user's opt-in) | not with `--goal` |
| `--goal` | Runs entirely in this session as one goal-driven loop: no Workflow, no fan-out | not with `--workflow` |
| `--worktree` | Builds in a fresh git worktree branched from the current `HEAD`; the current tree is never touched | |
| `--background` | Steps 2 onward run as one background agent; this session is free at once | |

`--workflow` and `--goal` together: stop and say pick one. `--migrate` without `--deploy`: say it does nothing alone and
carry on. Neither: run the parts in this session, handing well-specified
pieces to subagents (`implementer`, `mechanic`) where they fit, and never call Workflow.

## Never loosened

One shot skips questions, not rules. Every law, repo instruction and review the project requires still applies:
security and code reviews, existence-leak rules, never mutating a database without the user's go, branch and push rules.
Where a rule needs the user's word (a migration in a deploy without `--migrate`, a destructive step, a protected branch, a contradiction
with a law), it is the one place the run stops: finish everything that does not need it, then report what is waiting
and the exact go it needs.

## 1. Orient and set the goal

- Read the target (spec, plan, ADR, issue) and the code it names. The target wins over this skill; an ADR wins over its
  spec.
- Turn it into a checkable goal: the parts in order, each with its check (the tests that pin its rules, the gate, the
  reviews the repo requires). Write the goal's checks first where the target has none.
- **Budget.** With `--token-budget`, that is the ceiling. Without it, estimate from the target (its parts, the files
  they touch, the reviews and fixes after) and state it with one line of reasoning; take a stated budget in the target
  or the user's message (`+500k`) over the estimate. Keep about 15% back for the reviews, fixes and the report.
- Print the Plan (parts, files, checks, mode, budget) and Impact in one block, then carry on in the same turn.

## 2. Decide by default

Every open question gets the default, never a question to the user:
1. what the target, its ADR or the user said;
2. the target's own recommended default;
3. the existing pattern in the code next to it;
4. the simplest choice that meets the goal and is easiest to reverse.

Log each one as it is made (see "Decisions log"). A choice no default settles and that would be costly to reverse is
built the most reversible way and marked **check this first** in the log.

## 3. Build

Part by part, each to green before the next:
- write or adjust the tests that pin the part's rules, then the code, then run its check and loop until it passes;
- never skip, delete or weaken a test to go green;
- after a part that the repo's rules name for a review (auth, tokens, reach, sessions, RLS, OAuth, existence answers),
  run that review, fix confirmed findings in their own commits with a test, and log any left unfixed with the reason;
- with `--commit`, commit the part (only its files, never `git add -A`) with the attribution lines this session was given.

**`--workflow`:** load the `workflow-authoring` skill and write one Workflow per phase (build, then verify and review),
pipelined over the target's parts, with every `agent()` call carrying the options the session's hooks require. Pass the
budget in `args` and stop launching agents once `budget.spent()` passes it. Check each phase's results yourself before
the next: re-run its checks, never take an agent's "green" on its word.

**`--goal`:** do it all in this session, one part at a time, in a loop of build → check → fix until the goal's checks
all pass. No Workflow and no parallel fan-out; subagents only for a single bounded piece when it saves context.

**Budget running out:** at 85% spent, stop starting new parts. Finish or cleanly park the current one (committed if
`--commit`, else a list of what is uncommitted), and report what is left as the next run's target.

## 4. Finish

- Run the whole check: the repo's gate, the end-to-end tests, and the review of the whole diff the repo requires. Fix and
  re-run until green.
- Update the docs the target names (reference, concepts, plans, the ADR's status).
- `--push`: `git push -u origin HEAD` only, never force, never a protected branch. If an open PR's description lists
  the work, update it.
- `--deploy`: follow the workspace's own recipe (a project skill, a deploy doc, or a Naminé hand-off note's "Deploy
  recipe"), build from the committed HEAD, keep a rollback (image tag, database dump) first, and check health and the
  changed routes after. A migration in the deploy needs the user's go: `--migrate`, or their words in the invoking
  message. Without it, stop before deploying and say so.
- `--migrate` covers only the migrations this build added (named in the report), on the development deployment, after
  the dump. A migration from elsewhere in the deploy, or any other database write, still stops for the user.
- Save a hand-off: the `hand-off` skill's note, so a later session can pick up the decisions and anything left.

## `--worktree`

Run the build in a fresh git worktree (a subagent with `isolation: "worktree"`, or `EnterWorktree` when the build runs
in this session), branched from the current `HEAD`. Everything after step 1 happens there: tests, commits on its branch,
the push of that branch, and a deploy built from its `HEAD`. Leave the worktree in place and report its path and branch;
merging it back is the user's call. Prefer it whenever other work is going on in the same tree.

## `--background`

Do step 1 in this session (the goal, the budget, the Plan and Impact), then hand steps 2 to 4, the Decisions log and the
Reply to one background agent (`run_in_background: true`; with `--workflow` the Workflow itself runs in the background),
and say in one line that it is running. Give it the flags, the target, the goal, the budget and the attribution lines.
It cannot ask, so it stops and reports wherever this skill would: a migration without `--migrate`, an unclear failure, a
rule that needs the user. When it reports, re-run its final checks and read its commits before relaying them; don't take
its counts on its word. `--background` combines with `--worktree`, which is the safer choice for a long run.

## Decisions log

Keep it as you go, and put it in two places: a "Decisions (owner may reverse)" section at the end of the target's spec
or plan (committed with the work), and the report. One row each:

| # | Decision | Chose | Instead of | Where | To reverse |
|---|---|---|---|---|---|
| 1 | nav section name | "You" | "Your account" | `MainNav.tsx:150`, `a1b2c3d` | rename the label and its test |

Count only real choices: anything the target left open, a default taken over an alternative, a finding left unfixed, a
part dropped or parked. Not every line of code.

## Reply

1. **Done:** what was built, part by part, with the commits (short sha and subject) or the uncommitted file list.
2. **Checks:** each command and its counts; the reviews run and what they found and fixed.
3. **Decisions you can reverse:** the log table, the **check this first** rows on top.
4. **Waiting on you:** anything stopped for a rule (with the exact go it needs), anything parked by the budget.
5. **Budget:** used against the ceiling, and whether it was given or estimated.
6. The push and the deploy (with its rollback tag and the migrations `--migrate` applied), each only if its flag was
   set; with `--worktree`, its path and branch; and the hand-off note's link.
