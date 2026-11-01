---
name: one-shot
description: "Build a whole spec, plan step or large change end to end with no intervention, taking every default after an adversarial advisor has challenged it, keeping every unattended decision reversible, and report the decisions made (with the options considered and why) so the user can reverse them later. Flags: --commit, --push, --deploy, --migrate, --token-budget <n>, --workflow, --goal, --build-agent <type>, --advisor part|decision, --advisor-model <model>, --worktree, --background. Use when the user invokes /one-shot or asks to build something large unattended with all defaults (e.g. a step spec such as docs/plans/ui/step16c-spec.md). Not for small changes: those are /quick-change."
argument-hint: "<spec, plan or change> [--commit] [--push] [--deploy] [--migrate] [--token-budget <n>] [--workflow | --goal] [--build-agent <type>] [--advisor part|decision] [--advisor-model <model>] [--worktree] [--background]"
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
| `--build-agent <type>` | The subagent type that does every build step (in a Workflow, a goal or neither) | default `implementer` |
| `--advisor part\|decision` | How often the adversarial advisor challenges decisions: once per part (all its decisions together), or once per decision | default `part` |
| `--advisor-model <model>` | The model the advisor runs on (`opus`, `sonnet`, `haiku`, …), always at effort `high` | default `opus` |
| `--worktree` | Builds in a fresh git worktree branched from the current `HEAD`; the current tree is never touched | |
| `--background` | Steps 2 onward run as one background agent; this session is free at once | |

`--workflow` and `--goal` together: stop and say pick one. `--migrate` without `--deploy`: say it does nothing alone and
carry on. `--advisor` with any value other than `part` or `decision`: stop and say which two it takes. Neither: run the parts in this session, handing each well-specified build piece to the build agent, and never
call Workflow.

**The build agent** is `--build-agent`, else always `implementer`. It writes the code and tests of every part. Other work
keeps its own agent: reviews and the final checks run in this session (or as general agents that can load skills), and
read-only exploration may use `Explore`. A build agent that cannot load skills never runs `/security-review` or
`/code-review` itself; this session does.

## Never loosened

One shot skips questions, not rules. Every law, repo instruction and review the project requires still applies:
security and code reviews, existence-leak rules, never mutating a database without the user's go, branch and push rules.
Where a rule needs the user's word (a migration in a deploy without `--migrate`, a destructive step, a protected branch, a contradiction
with a law), or a decision is one-way with no reversible variant (step 2's gate), it is the one place the run stops: finish everything that does not need it, then report what is waiting
and the exact go it needs.

## 1. Orient and set the goal

- Read the target (spec, plan, ADR, issue) and the code it names. The target wins over this skill; an ADR wins over its
  spec.
- Turn it into a checkable goal: the parts in order, each with its check (the tests that pin its rules, the gate, the
  reviews the repo requires). Write the goal's checks first where the target has none.
- **Budget.** With `--token-budget`, that is the ceiling. Without it, estimate from the target (its parts, the files
  they touch, the reviews and fixes after) and state it with one line of reasoning; take a stated budget in the target
  or the user's message (`+500k`) over the estimate. Keep about 15% back for the reviews, fixes and the report.
- Print the Plan (parts, files, checks, mode, advisor mode and model, budget) and Impact in one block, then carry on in the same turn.

## 2. Decide by default, challenged, reversible

Every open question gets a decision, never a question to the user, in three steps.

**Propose** the default, and note which rung chose it and the other options seen:
1. what the target, its ADR or the user said;
2. the target's own recommended default;
3. the existing pattern in the code next to it;
4. the simplest choice that meets the goal and is easiest to reverse.

**Challenge** it with the adversarial advisor (see "Adversarial advisor") before building on it: with `--advisor part`, all of
a part's decisions at once before the part is built; with `--advisor decision`, each one as it comes up. A rung 1 decision
is the user's or the target's, so the advisor can flag a contradiction in it but never overturn it.

**Gate** it on reversibility. A decision is reversible when reverting this run's commits brings back the state before
it, with nothing lost and nothing outside the repo left changed. One-way examples: a migration that drops or rewrites
data, a contract that others consume once it is pushed (a public API, a schema, CLI flags or file formats), a message or
notification that is sent, a resource created outside the repo, a file deleted that git does not track.
1. If a reversible variant meets the goal, take it (an additive migration instead of a destructive one, a new field that
   is optional, the old route kept beside the new one, behaviour behind a flag), and log the one-way version it replaced.
2. If none does, don't take it. Build everything that does not depend on it, then report it under "Waiting on you" with
   the options written up (see "Decisions log").

Log each decision as it is made (see "Decisions log"). Mark as **check this first**: a decision taken against the
advisor's objection, a reversible variant taken in place of a one-way choice, and a rung 4 decision that would have
been costly to get wrong.

## Adversarial advisor

A second opinion briefed to disagree, so a default isn't taken just because it came first.

- **Who:** a read-only general agent (the Agent tool, or `agent()` in a Workflow) with `model: <--advisor-model, else
  "opus">` and `effort: "high"`. It reads the target, the code and the laws; it never edits, commits or runs anything that
  writes.
- **Brief, for each decision:** the question, the default proposed, the rung that chose it, the options already seen,
  and the files involved. Give it the facts, not the case for the default. It must:
  1. make the strongest case for the best alternative, including ones not listed;
  2. attack the default: what breaks, what the target, an ADR, a law or the nearby code contradicts, which edge case it
     misses;
  3. rate reversibility (two-way or one-way, with the reason), and for a one-way choice name a reversible variant if
     one exists.

  It answers each with `keep`, `switch to <option>` or `one-way`, plus its reasons.
- **This session decides.** Switch only on evidence: the target, the code, a law, or a concrete way it fails. Never
  switch on taste. When you keep a default the advisor objected to, log why. A `one-way` verdict goes through the gate
  even if this session disagrees; a `two-way` verdict doesn't excuse a choice the gate would catch.
- **Cost:** advisor calls count against the budget. Once spending passes 85%, no new parts start, so no new advisor
  calls start either.

## 3. Build

Part by part, each to green before the next:
- write or adjust the tests that pin the part's rules, then the code, then run its check and loop until it passes;
- never skip, delete or weaken a test to go green;
- after a part that the repo's rules name for a review (auth, tokens, reach, sessions, RLS, OAuth, existence answers),
  run that review, fix confirmed findings in their own commits with a test, and log any left unfixed with the reason;
- with `--commit`, commit the part (only its files, never `git add -A`) with the attribution lines this session was given.

**`--workflow`:** load the `workflow-authoring` skill and write one Workflow per phase (build, then verify and review),
pipelined over the target's parts, with every `agent()` call carrying the options the session's hooks require and every
build call `agentType: '<build agent>'`. The advisor runs as its own `agent()` call before the builds it
challenges, with `{ model: '<advisor model>', effort: 'high' }`, once per part or once per decision as `--advisor` says.
This session applies its verdicts before the build calls run. Pass the
budget in `args` and stop launching agents once `budget.spent()` passes it. Check each phase's results yourself before
the next: re-run its checks, never take an agent's "green" on its word.

**`--goal`:** do it all in this session, one part at a time, in a loop of build → check → fix until the goal's checks
all pass. No Workflow and no parallel fan-out; a subagent (the build agent) only for a single bounded piece when it saves
context.

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
and say in one line that it is running. Give it the flags, the target, the goal, the budget, the build agent, the advisor mode and model, and the attribution
lines; it runs the advisor itself. It cannot ask, so it stops and reports wherever this skill would: a migration without
`--migrate`, an unclear failure, a rule that needs the user, a one-way decision with no reversible variant. When it reports, re-run its final checks and read its commits before relaying them; don't take
its counts on its word. `--background` combines with `--worktree`, which is the safer choice for a long run.

## Decisions log

Keep it as you go, and put it in two places: a "Decisions (owner may reverse)" section at the end of the target's spec
or plan (committed with the work), and the report. One row each:

| # | Decision | Chose | Instead of | Advisor | Reversible | Where | To reverse |
|---|---|---|---|---|---|---|---|
| 1 | nav section name | "You" | "Your account" | keep | two-way | `MainNav.tsx:150`, `a1b2c3d` | rename the label and its test |

Count only real choices: anything the target left open, a default taken over an alternative, a finding left unfixed, a
part dropped or parked. Not every line of code. Under the table, write up each decision using the `explain` skill's
Structure (TL;DR, What it is, Major changes, Pros, Cons, Consequences, Other effects), plus a required
**Alternatives** section: every option considered (the advisor's included), the case for it, and why it wasn't chosen.

- **Full** for each **check this first** row and each one-way decision waiting on the user: every section, with at least
  one diagram following the `explain` skill's Diagrams rules (when options compete, draw each one). Consequences
  says how to reverse it and what that costs.
- **Compact** for the rest: the same headings, one line each, no diagram. Alternatives is never left out.

The spec's section and the hand-off note hold every write-up. The reply holds the table and the full write-ups.

## Reply

1. **Done:** what was built, part by part, with the commits (short sha and subject) or the uncommitted file list.
2. **Checks:** each command and its counts; the reviews run and what they found and fixed.
3. **Decisions you can reverse:** the log table with the **check this first** rows on top, then those rows' full
   write-ups. The compact ones are in the spec's section, which this links to.
4. **Waiting on you:** anything stopped for a rule (with the exact go it needs), each one-way decision with its full
   write-up and the options to pick from, and anything parked by the budget.
5. **Budget:** used against the ceiling, and whether it was given or estimated.
6. The push and the deploy (with its rollback tag and the migrations `--migrate` applied), each only if its flag was
   set; with `--worktree`, its path and branch; and the hand-off note's link.
