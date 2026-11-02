# Test-driven loop

Shared by `/quick-change` and `/one-shot`. Not a skill: read it where a skill points here.

## The test list

Before any code, write the rules the change must keep as a list of test names, each named for the rule it pins,
not the function ("an expired invite is refused", not "test_accept"). Each must fail if its rule changes. The test
list is a design decision, so it is written by the main session (or comes from the spec), never by the build agent.

## RED

Write the tests on the list, run them, and keep the failing output. A new test that passes before the change is
wrong or already satisfied: fix the test, or drop the item and say why. The report carries a `RED:` line with the
command and the failing lines.

## GREEN

Write the least code that makes the RED tests pass. From here the test files are read-only. Check it before
accepting the work:

```sh
git diff --stat <base> -- <the test paths>   # must print nothing; <base> is the tree after RED
```

A test that must change after RED (it was wrong) goes back to RED as its own step, with a line saying why. Never skip,
delete or weaken a test to go green.

## Check

The session re-runs the tests of what changed itself, and never takes a subagent's "green" on its word. The repo's
whole gate runs where the calling skill says (`/one-shot`: once, at the finish). A
refactor, if any, comes after green, in its own `refactor` commit, with the tests unchanged.

## Report lines

The build agent's success report adds, beside `Not done:`:
- `RED:` the command and the failing output from before the code.
- `Assumed:` every choice the brief didn't settle (a name, a placement, which helper was reused), each with
  `file:line`, or "none". This doesn't replace stopping on ambiguity: it catches the choices nobody saw as choices.
