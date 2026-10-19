---
name: adversarial-review
description: ALWAYS use this skill when the user asks for an adversarial review. Triggers whenever an adversarial review of changes, a pull request, a revision, a diff, or the working tree is requested (e.g. "run an adversarial review", "adversarially review this PR", "review this before I open the PR").
license: MIT
metadata:
  author: veeso
  version: "3.0.0"
  tags:
    - review
    - code-review
    - pull-request
    - conventions
---

# Adversarial Review

An adversarial review assumes the change is wrong until the code proves
otherwise. The reviewer's job is to find defects, not to approve. A review
that returns "looks good" must show the work that earned it.

The review runs as a loop. An independent reviewer reviews the change, an
independent fixer fixes every finding, the fixes are committed, and a fresh
reviewer reviews again, until a review comes back clean or the round limit is
reached. At the end all fix commits are squashed into the reviewed commit.

**Violating the letter of these rules is violating the spirit of them.**

## Roles

- **Orchestrator:** the current agent. It prepares the loop, dispatches the
  agents, commits, and squashes. It never reviews, never fixes, and never
  judges findings itself, even when it did not write the change.
- **Reviewer:** a fresh agent per round that runs the
  [Review Requirements](#review-requirements) and returns a report.
- **Fixer:** a fresh agent per round that fixes every finding in that round's
  report.

Every reviewer and fixer must be:

- a general-purpose agent with full tool access (it must be able to run
  builds and tests), never a read-only or search-only agent type;
- on the most capable model available (e.g. `opus` in Claude Code) with
  **medium** reasoning effort, unless the user asks for another model or
  effort;
- working in the current checkout, never in a separate worktree.

## Scope

Findings must stay strictly within the scope of the change: the reference
issue, ticket, PR description, or task the user gave. Unless the user says
otherwise:

- report only defects in the changed code, or defects the change causes or
  leaves incomplete (missing tests, docs, or call sites the intent requires);
- never report pre-existing problems in code the change does not touch, even
  when they look similar to the change;
- never fix anything outside the scope. A fix that needs code outside the
  scope is limited to the minimum the in-scope finding requires.

If the user widens or narrows the scope, pass their instruction to every
reviewer and fixer verbatim.

## Step 1: Prepare the Loop

1. Identify the target: a PR, a branch, a revision range, or the working
   tree. For a PR, check out its branch locally (for example
   `gh pr checkout <number>`), since fixes are committed on it.
2. Require a clean working tree. If the change, or anything else, is still
   uncommitted, stop and ask the user to commit or stash it. Fix commits must
   never mix with unrelated changes.
3. Record the scope source (issue, ticket, PR description, or user message)
   and write one sentence stating what the change must do.
4. Record the revision range under review, for example
   `"$(git merge-base HEAD origin/main)"..HEAD`, replacing `origin/main` with
   the actual base branch.
5. Record the **reviewed commit**: `REVIEWED_SHA="$(git rev-parse HEAD)"`.
   This is the commit all fixes are squashed into at the end.
6. Set the round limit: **5**, unless the user gives another value.
7. Create a session directory outside the repository with `mktemp -d` to keep
   each round's report and fixer summary. Never write review files inside the
   repository.

## Step 2: Run the Rounds

Set `round=1`, then repeat:

1. **Review.** Dispatch a fresh reviewer. Give it the PR URL or revision
   range from Step 1 (its end is always the current `HEAD`), the one-sentence
   intent, the scope source, any priorities or scope instructions from the
   user, and the full [Review Requirements](#review-requirements) section
   verbatim. Never give it implementation history, author rationale, earlier
   rounds' reports, your own conclusions, explanations of design choices, or
   suggested findings. Save its report to the session directory.
2. **Exit if clean.** If every section of the report (Blocker, Major, Minor,
   Nit, Scope) is "None.", stop the loop and go to
   [Step 3](#step-3-squash-the-fixes).
3. **Fix.** Dispatch a fresh fixer. Give it the report verbatim and complete,
   the one-sentence intent, the scope source, the user's scope instructions,
   and these rules:
   - fix every finding, nits included, with the smallest change that resolves
     its root cause;
   - stay within the [Scope](#scope); never refactor, rename, or clean up
     anything a finding does not require;
   - load any language or repository convention skill that matches the files
     it edits and follow it;
   - after fixing, run the build, linter, formatter, and the affected tests,
     and leave them all passing;
   - never commit, push, or create files in the repository that are not part
     of the fix; keep scratch files outside the repository;
   - skip a finding only when it can prove the finding wrong, and give that
     proof;
   - end with one line per finding: fixed, or skipped with the proof.

   Save its summary to the session directory.
4. **Commit.** Check `git status`. If the fixer changed nothing, stop the loop:
   the remaining findings are unfixed. Otherwise stage the fixer's changes and
   commit them with exactly this message, following the repository's signing
   configuration:

   ```bash
   git add -A
   git commit -m "fix: review round $round"
   ```

5. **Next round.** If `round` equals the round limit, stop the loop. Otherwise
   increment `round` and go back to 1.

Never push during the loop.

## Step 3: Squash the Fixes

If at least one `fix: review round` commit exists, squash all of them into the
reviewed commit, keeping its message and author:

```bash
git reset --soft "$REVIEWED_SHA"
git commit --amend --no-edit
```

Then confirm `git log` shows no `fix: review round` commit and that
`git diff "$REVIEWED_SHA" HEAD` contains only the fixes.

Do not push. If the reviewed commit was already pushed, tell the user the
branch now needs a force push and wait for their approval; never force-push on
your own. A general permission to push given earlier is not approval for a
force push.

## Step 4: Report to the User

Tell the user:

- how many rounds ran and why the loop stopped: clean review, round limit
  reached, or a fixer that changed nothing;
- each round's finding count per severity;
- every finding the fixers skipped, with their proof, verbatim;
- if the loop did not end on a clean review, the last reviewer report
  **verbatim and complete**, and that the last fixes were not re-reviewed;
- the path of the session directory holding every report and fixer summary.

Do not summarize, re-rank, or dismiss findings in this report.

## Review Requirements

These requirements apply to every reviewer.

### 1. Establish intent and scope

- Write one sentence stating what the change must do, from the PR
  description, the reference issue, or the user.
- List every changed file and map each hunk to that intent. A hunk that does
  not serve the intent is a **Scope** finding.
- List what the intent requires but the change lacks: docs, changelog, man
  page, help text, completions, config, migrations, tests.
- If a reference issue exists, check the change resolves all of it, not part.
- Report only findings within the scope of the change. Pre-existing problems
  in code the change does not touch are not findings, unless the user's
  instructions widen the scope.

### 2. Run the tooling

Detect the project's toolchain and run, on the change's head:

- build or type-check;
- the linter at the project's configured strictness, plus warnings as errors
  when the project allows it (e.g. `cargo clippy --all-targets`, `eslint`,
  `tsc --noEmit`, `ruff`);
- the formatter in check mode;
- the full test suite, or the affected packages when the suite is very slow.

Every warning the change introduces is a finding. If a tool cannot run, state
which and why at the top of the report and treat that area as unverified.

Load any language or repository convention skill that matches the changed
files and apply it to those files.

### 3. Walk every hunk with the checklist

Read every hunk and the surrounding code it depends on. Apply each lens below
to each hunk. Do not skip a lens because the hunk "looks fine".

- **Correctness:** empty, zero, one, max, unicode, and `None` inputs?
  Off-by-one? State reset between iterations? Ordering, races, partial
  failure?
- **Error handling:** can user input or I/O reach `panic`, `unwrap`,
  `expect`, `todo!`, `unreachable`, or an uncaught `throw`? Are errors
  propagated with context, never swallowed?
- **API and types:** borrow instead of own (`&[T]` not `&Vec<T>`, `&str` not
  `String`)? Needless `clone`, `collect`, or allocation? Public surface or
  wire format changed?
- **Performance:** work recomputed per item or inside a loop that could be
  hoisted? Extra syscalls, allocations, or N+1 queries on a hot path?
- **Readability:** clear names? Dead code, leftover `TODO` or `FIXME`, debug
  prints, commented-out code? Copy-pasted logic that should be shared?
- **Docs and comments:** is every comment and doc comment near the change
  still true? Typos in user-facing strings, help text, or errors? README,
  changelog, and man page updated?
- **Consistency:** does the change follow the codebase's existing idioms? Is
  a new helper used at every existing call site it fits? If the change fixes
  a bug, does the same bug stay unfixed in code the intent covers?
- **Security:** untrusted input validated? Injection, path traversal,
  secrets, permissions, trust boundaries?
- **Low-hanging fruits:** one-line simplifications a reviewer would ask for:
  iterator instead of loop, early return, standard library helper, removed
  indirection.

### 4. Audit the tests

- For each changed behavior, name the test that fails if the behavior breaks.
  No such test is a **Major** finding: missing coverage.
- For each new or changed test, state what makes it fail. An assertion that
  passes on a crash (only "exit code is non-zero", empty substring match,
  `assert!(result.is_err())` with no error check) is ineffective: a **Major**
  finding.
- Repeated tests: two tests with the same setup and assertion shape that
  differ only in input data should be one table-driven or parametrized test.
  Tests that exercise the same code path twice add cost, not coverage:
  **Minor**.
- Tests already implemented: for each new test, search the existing suite for
  a test that covers the same behavior with the same setup and assertions. A
  new test that repeats an existing one adds nothing: **Minor**. Extend the
  existing test instead.
- Missing cases: boundaries, error paths, combinations with existing flags or
  options, and the reverse order of anything order-sensitive. Each untested
  case on a changed path is a **Major** finding; elsewhere it is **Minor**.
- Fixtures duplicated from existing fixtures instead of reused: **Minor**.

### 5. Verify every finding

Before reporting a finding, try to prove it: run the code, write a throwaway
test outside the repository, read the dependency source in the local cache or
vendored tree, or check the docs. A finding you could not verify is dropped,
not reported. Never ask the author or the user questions in the report; either
prove a defect or say nothing. Do not modify the repository under review.

### 6. Report

Use exactly this structure. Every section is required; write "None." when a
section is empty.

```markdown
## Adversarial review: <change title>

**Intent:** <one sentence>
**Tooling:** <command: result, for each tool run; tools that could not run and why>
**Reviewed:** <every changed file, comma-separated>

### Blocker

### Major

### Minor

### Nit

### Scope
```

Severity:

- **Blocker**: wrong behavior, crash, data loss, security hole, build or test
  failure. Must be fixed before merge.
- **Major**: likely bug on an edge case, missing or ineffective test for
  changed behavior, breaking change without notice, real performance cost.
- **Minor**: bad practice, needless allocation, stale or misleading doc,
  repeated test, missed reuse, low-hanging fruit.
- **Nit**: naming, typos, wording, formatting the tooling did not catch.

Each finding states: `file:line`, what is wrong, how to trigger or observe it,
impact, and the fix. One finding per root cause; merge duplicates.

Report nits. Pedantry is the point of this review. A review may conclude with
no Blocker or Major findings only when every changed file went through steps 3
and 4, the Reviewed line lists all of them, and the Tooling line shows the
tools ran. Do not print per-file or per-lens tables; report findings only.

## Red Flags

These thoughts mean you are about to break the review. Stop and follow the
rules above.

| Thought                                     | Reality                                                                  |
| ------------------------------------------- | ------------------------------------------------------------------------ |
| "Looks good overall"                        | Overall is not a lens. Walk every file through every lens first.         |
| "Too minor to mention"                      | Minor and Nit sections exist for it. Report it.                          |
| "Existing code does the same"               | Out of scope unless the change touches it. Report only what is in scope. |
| "While we are here, let's fix this too"     | Out of scope. Neither the reviewer nor the fixer touches it.             |
| "Tests pass, so it works"                   | Check the tests would fail if it did not work.                           |
| "Style is subjective"                       | If the linter or codebase idiom disagrees, it is not subjective.         |
| "The author probably meant that"            | Review the code, not the intent you imagine.                             |
| "Pretty sure this API does not exist"       | Verify in the source or docs. Unverified means not reported.             |
| "Worth asking the author about this"        | Questions are noise. Prove a defect or drop it.                          |
| "I can review or fix this myself"           | The orchestrator only dispatches, commits, and squashes.                 |
| "The reviewer should see last round's list" | Every round gets a fresh reviewer with no earlier reports.               |
| "One more round past the limit"             | The limit holds. Report what remains.                                    |
| "I'll summarize the remaining findings"     | Relay verbatim. Summaries are where findings disappear.                  |
| "The branch needs a force push now"         | Ask the user first. Never force-push on your own.                        |
