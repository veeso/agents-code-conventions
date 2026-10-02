---
name: adversarial-review
description: ALWAYS use this skill when the user asks for an adversarial review. Triggers whenever an adversarial review of changes, a pull request, a revision, a diff, or the working tree is requested (e.g. "run an adversarial review", "adversarially review this PR", "review this before I open the PR").
license: MIT
metadata:
  author: veeso
  version: "2.0.0"
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

**Violating the letter of these rules is violating the spirit of them.**

## Who Reviews

The current agent is **implementation-involved** if it wrote, edited,
directed, or designed the changes, or is continuing in the context where they
were made. Reading the PR or starting a review does not count.

### Implementation-involved: launch one fresh reviewer

The current agent cannot review its own work. Launch exactly one reviewer:

- use a general-purpose agent with full tool access (it must be able to run
  builds and tests), never a read-only or search-only agent type;
- use the same model as the current session or a stronger one;
- give it the PR URL or the final revision range, the intended externally
  observable behavior, any reference issue, any priorities the user asked
  for, and the full [Review Requirements](#review-requirements) section
  verbatim.

Never give the reviewer implementation history, author rationale, your own
conclusions, explanations of design choices, or suggested findings.

Relay the reviewer's report to the user **verbatim and complete**, nits
included. Do not summarize it, re-rank it, dismiss findings, or fix anything
until the user decides. If behavior-changing fixes follow, run another fresh
review. Purely mechanical follow-ups (formatting, renames with no semantic
effect) may skip it.

### Not involved: review directly

Perform the review in the current session. Do not launch another agent to
repeat the full review. You may delegate a narrow, distinct slice (one
platform path, one exploit hypothesis, one dependency) with explicit
boundaries; you remain responsible for merging, de-duplicating, and verifying
delegated results.

## Review Requirements

These requirements apply to every reviewer, direct or delegated.

### 1. Establish intent and scope

- Write one sentence stating what the change must do, from the PR
  description, the reference issue, or the user.
- List every changed file and map each hunk to that intent. A hunk that does
  not serve the intent is a **Scope** finding; ask the user whether it should
  stay or be removed.
- List what the intent requires but the change lacks: docs, changelog, man
  page, help text, completions, config, migrations, tests.
- If a reference issue exists, check the change resolves all of it, not part.

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
  a new helper used at every existing call site it fits? Does the same bug
  or pattern exist elsewhere and stay unfixed?
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
- Missing cases: boundaries, error paths, combinations with existing flags or
  options, and the reverse order of anything order-sensitive. Each untested
  case on a changed path is a **Major** finding; elsewhere it is **Minor**.
- Fixtures duplicated from existing fixtures instead of reused: **Minor**.

### 5. Verify every finding

Before reporting a finding, try to prove it: run the code, write a throwaway
test outside the repository, read the dependency source in the local cache or
vendored tree, or check the docs. A finding you could not verify goes to
**Open questions**, never into a severity bucket. Do not modify the
repository under review.

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

### Open questions
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

Report nits. Pedantry is the point of this review; the author decides what to
skip, not the reviewer. A review may conclude with no Blocker or Major
findings only when every changed file went through steps 3 and 4, the
Reviewed line lists all of them, and the Tooling line shows the tools ran.
Do not print per-file or per-lens tables; report findings only.

## Red Flags

These thoughts mean you are about to under-report. Go back to step 3.

| Thought                                  | Reality                                                                |
| ---------------------------------------- | ---------------------------------------------------------------------- |
| "Looks good overall"                     | Overall is not a lens. Walk every file through every lens first.       |
| "Too minor to mention"                   | Minor and Nit sections exist for it. Report it.                        |
| "Existing code does the same"            | Existing debt does not excuse new debt. Report it; note the precedent. |
| "Tests pass, so it works"                | Check the tests would fail if it did not work.                         |
| "Style is subjective"                    | If the linter or codebase idiom disagrees, it is not subjective.       |
| "The author probably meant that"         | Review the code, not the intent you imagine. Ask in Open questions.    |
| "Pretty sure this API does not exist"    | Verify in the source or docs. Unverified goes to Open questions.       |
| "I'll summarize the reviewer's findings" | Relay verbatim. Summaries are where findings disappear.                |
