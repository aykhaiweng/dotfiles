# Shipping: commit, push, deploy, worktree, background

Shared by `/quick-change` and `/one-shot`. Not a skill: read it where a skill points here. Each step runs only when
the one before it succeeded: never commit, push or deploy what did not verify.

## `--commit`

- Commit only the files of this work, never `git add -A`: other sessions may have uncommitted work in the same tree.
  Mention anything else uncommitted rather than touching it.
- A Conventional Commit, `type(scope): subject` with a 2-4 line body (what, why, the alternative rejected), ending
  with the attribution lines this session was given.
- Follow the git-workflow law for the branch, including its repo exceptions (for example dotfiles commits to `main`
  through `git -C <path>`).

## `--push`

`git push -u origin HEAD` only (or the form the git-workflow law gives for the repo). Never force, never a protected
branch the law doesn't except. If the branch has an open PR whose description lists the work, update it or offer to.

## `--deploy`

Deploy the way this workspace already does, and only to its development or throwaway deployment:
- Find the recipe: a project skill, `docs/development.md` or a deploy doc, the repo's scripts, or a Naminé note (a
  hand-off note's "Deploy recipe"). In a git worktree, use the deployment that worktree runs on (for example a local
  container on a dev port). No recipe found, or only production: stop and say so.
- Build from the committed HEAD (e.g. `git archive HEAD | docker build -`), so uncommitted work never ships.
- Keep a way back first, as the recipe does it (a rollback image tag, a database dump).
- A database migration in the deploy needs the user's explicit go (the invoking message, or a flag the skill defines):
  otherwise stop before deploying and say so.
- Afterwards, check it is up (the health endpoint, the routes the change touched) and report the rollback tag.

## `--worktree`

Work in a fresh git worktree branched from the current `HEAD` (a subagent with `isolation: "worktree"`, or
`EnterWorktree` when the work runs in this session). Everything after the planning step happens there: checks,
commits on its branch, its push, and a deploy built from its `HEAD`. The current tree and branch are never touched;
the worktree guard hook refuses file writes into them. Before reporting, confirm the main checkout's `git status` is
what it was at the start (the guard doesn't see Bash writes). Leave the worktree in place and report its path and
branch; merging it back is the user's call.

## `--background`

Do the planning step in this session, then hand the rest to one background agent (`run_in_background: true`) and say
in one line that it is running. Give it the skill's remaining steps and its Reply section, this file, the flags, the
brief or goal, and the attribution lines. It cannot ask, so it stops and reports wherever the skill would ask. When it
reports, re-run its checks and read its commits before relaying them; don't take its counts on its word. It combines
with `--worktree`, the safer choice when other work is going on in the same tree.
