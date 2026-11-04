---
name: resolve-pr
description: "Check out a pull request's branch in this tree, merge its base in, resolve the conflicts through a subagent (implementer by default), verify, commit the merge and push it, then return to the original cwd and branch with any stashed work restored. Flags: --agent <type>, --no-push. Use when the user invokes /resolve-pr, or asks to resolve, fix or clear the merge conflicts on a PR (a number, URL or branch). Not for rebasing or rewriting a PR's history, and not for conflicts in the current branch's own merge (resolve those in place)."
argument-hint: "<PR number | PR URL | branch> [--agent <type>] [--no-push]"
---

# Resolve a PR's merge conflicts

Point at the PR in `$ARGUMENTS`, merge its base into its head, resolve, verify, commit, push, and come back.

## Flags

| Flag | Does | Default |
|---|---|---|
| `--agent <type>` | Which subagent resolves the conflicts | `implementer` |
| `--no-push` | Commit the merge but leave the push to the user | push |

**Merge, never rebase.** The base is merged into the PR branch (`merge: <base> into <head>`), so the branch's history
and its reviews are untouched and nothing is force-pushed. A `--rebase` in the arguments is not a flag here: say so.

**Always come back.** From step 2 on, every exit (success, a stop, a failed check, an error) runs step 7. Never end
the turn on the PR's branch, in a different cwd, or with the stash still held.

## 1. Point at the PR

- `gh pr view <arg> --json number,url,state,headRefName,baseRefName,isCrossRepository,maintainerCanModify,mergeable`.
  A branch name works as `<arg>` too. Not found, closed or merged: stop (nothing to restore yet).
- `mergeable` of `MERGEABLE`: say there's nothing to resolve and stop. `UNKNOWN`: carry on, the merge will tell.
- Cross-repository PR without `maintainerCanModify`: the push will be refused. Say so and treat it as `--no-push`.
- The head branch is protected (`main`, `master`, `dev`, `staging`): stop, never merge into it from here.

## 2. Record where we are

Save these and say them in one line, since step 7 restores exactly them:
- `ORIG_CWD` = `pwd`, `ROOT` = `git rev-parse --show-toplevel`;
- `ORIG_REF` = `git symbolic-ref --short -q HEAD`, or the detached sha from `git rev-parse HEAD`;
- a mid-operation tree (`.git/MERGE_HEAD`, `rebase-merge`, `rebase-apply`, `CHERRY_PICK_HEAD`): stop, it's the
  user's work in progress;
- uncommitted or untracked work: `git stash push -u -m "resolve-pr <number> <ISO time>"` and save the stash's sha
  (`git rev-parse stash@{0}`) as `STASH`, so step 7 pops that one even if another stash lands on top. Say what was
  stashed (`git stash show --include-untracked --name-only "$STASH"`).

All later git commands run as `git -C "$ROOT" …`, so a `cd` in between can't send them to the wrong tree.

## 3. Check out and merge

- `gh pr checkout <number>`, then `git pull --ff-only` so the local branch matches the PR's head. A local branch
  that has diverged from the remote: stop (step 7), the user has unpushed commits there.
- `git fetch origin <base>` and `git merge --no-ff --no-commit origin/<base>`.
- No conflicts: still verify (step 5) before committing; a clean textual merge can break the build.
- List the conflicted files (`git diff --name-only --diff-filter=U`) and, for each, the commits on both sides that
  touched it (`git log --oneline origin/<base>...HEAD -- <file>`).

## 4. Resolve

Hand the conflicts to the subagent (`--agent`, default `implementer`) with a complete brief:
- the PR (number, title, head, base) and its description (`gh pr view <number> --json title,body`);
- each conflicted file, with both sides' commits from step 3 and what each side meant to do (from their messages and
  the PR body);
- the rule: **keep both sides' intent.** Where both can't hold, or the resolution needs a design call (an API
  shape, a schema, a security behaviour, which of two rules wins), don't pick one: leave the file conflicted and
  report the choice with each option;
- touch only the conflicted files plus what the merge itself needs to compile (an import, a renamed call), and list
  those extra edits;
- no commit, no push, no `git merge --continue`/`--abort`, no checkout;
- report: each file and how it was resolved, the extra edits, any files left conflicted with the choice they need,
  and `Assumed:` lines.

A file left conflicted for a design call: ask the user (it's theirs), then resolve it in this session or re-brief
the agent with the answer. While waiting, the tree stays mid-merge on the PR branch; say so plainly.

## 5. Verify

Run the checks yourself; don't take the agent's word for them.
- No conflict markers left: `git diff --check` and `rg -n '^(<{7}|={7}|>{7})( |$)'` over the resolved files.
- The repo's own gate (its CLAUDE.md, docs, package scripts, or the Stop hook's command). In a workspace whose
  packages consume each other's build output, build them first, or the check runs against stale `dist`.
- Read `Assumed:`; fix any that contradicts either side's intent.

Failing, and not fixable without a design call: save the work with
`git -C "$ROOT" diff HEAD > <scratchpad>/resolve-pr-<number>.patch`, `git merge --abort`, and go to step 7. Name the
patch path in the reply.

## 6. Commit and push

- `git add` the resolved files and the listed extra edits only, never `-A`.
- `git commit` with the subject `merge: <base> into <head>` and a body naming each conflicted file and how it was
  resolved, ending with this session's attribution lines.
- Push unless `--no-push` (or the cross-repo case): `git push` to the PR's head, never `--force`. A rejected push
  (the head moved): don't force. Stop, say so, and leave the merge commit on the local branch.
- `--no-push`: give the push as a `! git push` line, to run from the PR branch.

## 7. Come back

Always, in this order:
1. A merge still in progress here: `git merge --abort` (after saving the patch, as in step 5).
2. `git -C "$ROOT" checkout "$ORIG_REF"` (the detached sha, if it was one).
3. `STASH` set: find its current entry, since `pop` takes only a `stash@{n}` and not a sha:
   `REF=$(git -C "$ROOT" stash list --format='%gd %H' | awk -v s="$STASH" '$2==s{print $1}')`, then
   `git -C "$ROOT" stash pop --index "$REF"`. No entry matches: stop, say so, and never pop `stash@{0}` blindly. A
   pop conflict: stop, never drop the stash; say it's still held under `$REF` and how to finish.
4. `cd "$ORIG_CWD"`.
5. Confirm: `git branch --show-current` (or the sha), `pwd`, and `git status --short` match step 2's record.

## Reply

- The PR, base and head, and whether it was pushed (with the new head sha), or why not.
- Each conflicted file and how it was resolved (`file:line` where it matters); the extra edits; the `Assumed:` lines
  kept.
- The verify commands and their counts.
- Back on `<ORIG_REF>` in `<ORIG_CWD>`, stash restored (or what's still held and why).
- Anything left for the user: a design call, a refused push, a patch path.
