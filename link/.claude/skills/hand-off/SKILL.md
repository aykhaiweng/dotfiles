---
name: hand-off
description: "Save a hand-off note for the current work (where it stands, what was done, what is next, decisions still open) to Naminé, or to /tmp when Naminé is unavailable, and print a prompt that continues the work in a fresh session. Use when the user invokes /hand-off, or asks to hand off, wrap up for a new session, or write a continuation prompt."
argument-hint: "[what to hand off; default: this session's work]"
---

# Hand-off

Hand off `$ARGUMENTS` (default: the work of this session) so a fresh session,
which remembers nothing of this one, can carry on without asking what happened.

## Gather

Read the state; don't write it from memory.

- **Git:** repo root, branch, `HEAD` short sha, `git status --short`, and this
  session's commits (`git log --oneline <first>^..HEAD`). Say if anything is
  uncommitted.
- **The work:** the plan, spec, ADR or issue driving it, the step reached, and
  the next step.
- **Decisions:** what was decided this session and by whom (the user, or a
  builder's choice the user may reverse), and what is still the user's to
  decide. List open decisions, don't settle them in the note.
- **Verification:** the last test or gate run: the command, the result and the
  commit it ran on. Mark anything not verified as such.
- **Gotchas** found, each with its fix.
- **Background work** still running (jobs, workflows, agents): a fresh session
  cannot see it, so name it and where its output lands.

No secrets: no tokens, passwords or connection strings with credentials. Point
to where they are documented instead (e.g. `docs/development.md`).

## Write the note

```markdown
# Hand-off: <task> (<repo>@<branch>, <YYYY-MM-DD>)

**Where it stands:** two or three plain sentences.

**Done:** `<sha>` <subject>, one per line (or a range and a count when long).

**Next:** an ordered list; the first item concrete enough to start on without asking.

**Open decisions (the user's):** each with the recommended default, or "none".

**Verify:** the exact commands, and where their environment is documented.

**Gotchas:** symptom, cause, fix.

**Read first:** files, notes or docs, with paths.
```

Keep it short enough to read in a minute. Plain words first, then the exact
detail.

## Save it

1. **Naminé**, when the `namine` MCP tools are present (load them with
   ToolSearch `select:mcp__namine__get,mcp__namine__remember,mcp__namine__update`
   if they are deferred):
   - Slug: `hand-off-<branch>`, lowercased, every character outside `[a-z0-9-]`
     turned into `-`.
   - `get` that slug. If an active note comes back, `update` it (its `id`, its
     revision as `base_revision`, the new `body` and `title`, `model`), so the
     earlier hand-off stays in its history. Otherwise `remember` with
     `type: log`, the slug, a title, the body, `why: "Hand-off so a fresh
     session can continue <task>."`, and `model`. Keep the default binding.
   - The note's link is `<server>/notes/<id>`, where `<server>` is the
     `[servers.<name>] url` in `~/.config/namine/config.toml`.
   - If the write fails (no source, server unreachable, refused), fall back to
     a file and say why.
2. **Otherwise**, write `/tmp/hand-off-<repo>-<branch>-<YYYYMMDD-HHMM>.md`. Use
   `/tmp`, not a job scratch directory: the file must outlive this session.

## Print the prompt

One fenced block, ready to paste into a new session:

```text
Continue <task> in <repo path> on branch <branch> (HEAD <sha>).
Read the hand-off first: Naminé note `<slug>` (namine MCP `get`, slug "<slug>"; <link>)   ← or: the file <path>
In short: <two to four lines: where it stands and the next step>.
Open decisions for me: <each, with your recommended default> | none.
Start with: <the first concrete action>.
```

Put the key facts inline as well, so the prompt still works if the note
cannot be read. Keep it under about 15 lines. Leave out the user's laws and
preferences: the new session loads them itself.

## Reply

One line saying where the note is (its link or path), then the prompt block.
Nothing else.
