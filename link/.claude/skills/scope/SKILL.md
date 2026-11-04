---
name: scope
description: "Explore and plan a change before it is built: read the code and context, ask the user only the decisions that need them (each explained in full), recommend the rest for one sign-off, and write a spec that /one-shot can build without defaulting anything, ending with the recommended /one-shot command (or /quick-change when the blast radius is small). Flags: --one-shot (run that command at the end), --recommend (no questions: every decision is a recommendation to approve). Use when the user invokes /scope, or asks to scope, explore or plan a change for /one-shot. The planning half of /one-shot: /one-shot builds a finished spec unattended; /scope makes that spec with the user. Writes no code."
argument-hint: "<the change, issue, ADR or thread> [--one-shot] [--recommend]"
---

# Scope

Turn `$ARGUMENTS` (the change, plus any flags) into a spec that `/one-shot` can build with every decision already the
user's. `/one-shot` never asks and takes defaults; `/scope` is where the asking happens, so that every decision reaches
`/one-shot` as rung 1 ("what the target, its ADR or the user said").

The invocation is the go-ahead to explore and to write the spec file. It is not a go-ahead for code: `/scope` writes
none, and edits no file but the spec.

## Flags

| Flag | Does |
|---|---|
| (none) | Explores, asks the few decisions that need the user, recommends the rest, writes the spec, and ends with the recommended `/one-shot` command, or `/quick-change` for a small change |
| `--recommend` | No dialogs: every decision, the ones that would be asked included, goes in the recommendations table for one sign-off (step 3) |
| `--one-shot` | The same, then runs that command (the `one-shot` skill, with the spec and the recommended flags) |

## 1. Orient

- Read the target (the request, an ADR, an issue, a thread or plan note) and the code it touches: the files, their
  callers and exports, their tests, the commands that verify them. Hand a broad read-only sweep to `Explore` agents in
  parallel; read the files the spec will name yourself.
- Read the project's memory for it: settled-decision notes (`settled-*`), open threads and gotchas on the same area.
  Anything already settled there is rung 1 and is not asked again; say which note settled it.
- Read the laws and repo instructions that will bind the build (reviews it needs, branch rules, migrations, existence
  answers), so the spec names them instead of `/one-shot` finding them.
- Find where specs live in this repo (e.g. `docs/plans/`) and the shape of the ones already there.

## 2. List the open questions

Every choice the target leaves open, including ones the code next to it would seem to answer: the scope (what is in and
out), the parts and their order, interfaces (API, schema, CLI flags, file formats), names, data and migrations, error
answers, the test list of each part, where the spec goes, and which `/one-shot` flags the run should use.

For each, note:
- the options (the ones the target names, the existing pattern in the code, the simplest one, and any other a peer
  would raise), with a one-line case for each;
- the one you recommend, and why;
- whether it is **two-way** (reverting the build's commits restores the state before it) or **one-way** (a destructive
  migration, a pushed public contract, anything sent or created outside the repo), and for a one-way choice, the
  reversible variant if one exists.

Never drop a question because it seems obvious: an obvious default is still `/one-shot`'s to take unless the user takes
it here, so it goes in the recommendations table.

Then sort each question into one of two groups:

- **Ask** only when at least one holds: it is one-way; it changes a security boundary or an existence answer; it fixes a
  public contract (an API, a schema, a file format, a CLI command or flag); it changes what a user sees or does; or the
  two best options are close and the choice is a matter of taste or product direction. Aim for six or fewer; if more
  qualify, keep the costliest and move the two-way rest to **Recommend**.
- **Recommend** everything else: names, internal structure, part order, test lists, where the spec goes, the `/one-shot`
  flags, and any choice the code or memory already points one way.

With `--recommend`, every question is **Recommend**.

## 3. Ask the few, recommend the rest

The user must understand each decision before they make it. Short questions they cannot follow are worse than none.

**Asked questions**, in rounds of at most three (prefer one or two), one-way and costly ones first:

1. **Brief in chat first.** Before each dialog, write a section per question: what it is about and why it is open,
   in plain words before technical ones; what each option means concretely (what the user would see, type or get, an
   example where one helps); what each costs and whether it can be undone; and the recommendation with its reason.
   Use a small diagram or file snippet when the options differ in shape.
2. **Then the dialog** (`AskUserQuestion`). The dialog may be all the user sees, so each question is a full sentence
   that names the thing, the stakes and the recommendation. Each option's description is one to three sentences: what
   happens if chosen, what it costs, one-way or two-way. Use `preview` (single-select) to show what each option looks
   like: the file, the command output, the diagram. The recommended option comes first, marked "(Recommended)".

**Recommendations**, after the asked questions (their answers may change them): one table in chat, numbered, with the
decision, the recommendation, the reason in one plain sentence, and the main alternative. Then one dialog: "Accept all N
recommendations in the table above?", with the options to accept all or to name the rows to change. A changed row that
turns out to need a real choice becomes an asked question in the next round. Approved rows are the user's decisions,
not defaults.

- An answer that opens new questions (a new part, a changed interface) sorts them again and puts them in the next round.
- An answer that contradicts a law or the target's ADR: stop and ask whether to change the rule or make an exception,
  as the memory policy says. Never write the contradiction into the spec.
- A one-way choice is never settled by the table's "accept all" alone. In the table it is listed first, marked
  **one-way**, and needs its own explicit go. The user's go is written down as theirs, with the reversible variant noted
  as rejected, so `/one-shot`'s gate reads it as the user's go and does not stop on it.
- Keep going until every question is asked or approved. If the user says to stop, the rest are written as **Open** in
  the spec, never as defaults, and the recommended command leaves `--one-shot` unrun (see step 5).

## 4. Write the spec

`<specs dir>/<slug>-spec.md`, in the repo's spec shape where one exists, holding what `/one-shot` step 1 reads:

1. **Goal:** the change in two or three sentences, and the check that proves it is done (the gate, measured numbers for
   a performance goal).
2. **Parts**, in build order. Each with: the files to create, modify or delete and what changes in each; its test list,
   one line per rule the tests pin, named for the rule; its gate command; the reviews the repo requires after it.
   A part with no behaviour to pin says so.
3. **Decisions (settled by the owner):** every question from step 3, one row each: decision, chosen, instead of, one-way
   or two-way, and who settled it (the user on `<date>`, asked or approved from the recommendations table, or the note
   or ADR it came from).
4. **One-way items:** each with the user's go, quoted, and the reversible variant rejected.
5. **Open:** only if the user stopped the asking; each question with its options and the recommendation.
6. **Out of scope:** what was considered and left out, so a builder does not add it.
7. **Budget:** a token estimate for the build with one line of reasoning (`/one-shot` takes it over its own).

Name exact files, signatures and commands; a builder must never need to make a design call from this spec. Leave the spec
uncommitted unless the user asked for a commit: `/one-shot --commit` adds its decisions to the same file and commits it
with the work.

## 5. Hand off

Print the recommended command alone on its own line, with the flags the user chose in step 3, and one line on why each
flag is there:

`/one-shot <spec path> [flags]`

- **Small blast radius, without `--one-shot`:** when the change passes `/quick-change`'s step 1 ("Is it quick?": none of
  its stop conditions hold), recommend `/quick-change` instead, with the change in one sentence that names the spec, and
  only the flags it takes (`--commit`, `--push`, `--deploy`, `--agent`, `--worktree`, `--background`):

  `/quick-change <the change, per <spec path>> [flags]`

  Say in one line which of its conditions made it small.
- **`--one-shot`:** run the `/one-shot` command now through the `one-shot` skill with exactly that argument string,
  however small the change. Not when the spec has an **Open** section: then say which questions are open and that
  `/one-shot` would default them, and wait for the user.
- Without `--one-shot`, stop here.

## Reply

1. **Spec:** its path, and its parts in one line each.
2. **Decisions:** the settled table (or a link to it in the spec), with the one-way items on top, each marked asked or
   approved.
3. **Open:** anything left open, or "none".
4. **Next:** the recommended `/one-shot` (or, for a small change, `/quick-change`) command, alone on its line, or that
   `/one-shot` is running now.
