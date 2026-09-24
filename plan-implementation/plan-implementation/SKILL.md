---
name: plan-implementation
description: ALWAYS use this skill when the user asks to plan, design, or write the implementation plan for a task, feature, bug fix, or issue (e.g. "plan the implementation of #42", "design how to implement X", "write a plan for this issue", "how would you implement this? write it down"). Produces a scope-bound, test-driven implementation plan on top of the superpowers writing-plans skill, stores it in the right place, never commits it by accident, and never starts execution.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - planning
    - implementation-plan
    - superpowers
    - testing
    - conventions
---

# Plan Implementation

Use this skill to turn a task, feature request, bug report, or issue into a
written implementation plan that another agent session can execute without any
extra context. This skill only **writes** the plan. It never executes it.

This skill is a layer of rules on top of the `superpowers` skill suite. The
superpowers `writing-plans` skill defines the plan format and process. This
skill adds scope, testing, storage, git, and handoff rules that take precedence
over `writing-plans` wherever the two disagree.

## Rule Precedence

Apply rules in this order, highest first:

1. **Explicit user requirements** given in the current conversation. Any rule
   below may be overridden by the user. When the user overrides a rule, follow
   the override and record it in the plan's `Global Constraints` section so the
   executing session also honors it.
2. **Repository conventions**, stated in files such as `CLAUDE.md`,
   `AGENTS.md`, `GEMINI.md`, `CONTRIBUTING.md`, or equivalent agent/contributor
   guidance in the repository.
3. **This skill.**
4. **The superpowers `writing-plans` skill** and other superpowers skills.

## Step 1: Verify the Superpowers Suite

Before doing anything else, verify that the superpowers skills are available in
the current agent environment. The required skills are:

| Skill                                     | Why it is needed                                              |
| ----------------------------------------- | ------------------------------------------------------------- |
| `superpowers:writing-plans`               | Defines the plan document format and planning process         |
| `superpowers:test-driven-development`     | Defines the test-first discipline every plan task must follow |
| `superpowers:executing-plans`             | Referenced in the plan header for the executing session       |
| `superpowers:subagent-driven-development` | Referenced in the plan header for the executing session       |

How to check depends on the agent:

- If the agent has a skill tool or skill listing, look for the skills above by
  name.
- Otherwise, look for the skill files on disk, for example
  `~/.claude/plugins/cache/*/superpowers/*/skills/writing-plans/SKILL.md`,
  `~/.claude/skills/`, `~/.agents/skills/`, or the project's `.claude/skills/`
  and `.agents/skills/` directories.

If **any** required skill is missing, you MUST flag it to the user before
writing the plan:

- Name each missing skill explicitly.
- Tell the user how to install the suite (for Claude Code:
  `/plugin install superpowers@claude-plugins-official`; for other agents, see
  <https://github.com/obra/superpowers>).
- Ask whether to stop, or to continue by following the rules of this skill
  alone. Do not silently continue.

If `writing-plans` is available, load it now and follow it for the plan format,
task structure, "No Placeholders" rules, and self-review, subject to the
overrides in this skill.

## Step 2: Understand the Task and Its Scope

1. Identify the source of the task: a user message, an issue (for example a
   GitHub issue read with `gh issue view <number>`), a ticket, or a spec file.
   Read it completely, including comments.
2. Record the **issue number** if one exists. It is needed for the final
   squash commit (`closes #<number>`). If the task clearly comes from an issue
   but no number is known, infer it from the branch name (for example
   `fix/404-broken-login` or `issue-404`) or ask the user. If there is no issue
   at all, say so in the plan and omit the `closes` footer.
3. Explore the codebase enough to know which files, modules, and tests are
   involved. Read the repository's agent and contributor guidance.
4. If the requirements are ambiguous in a way that changes the design, ask the
   user before writing the plan. Do not invent requirements.

### Scope Rules

The plan must strictly stick to the scope of the task or issue, unless the user
explicitly says otherwise.

- Every task in the plan must be required to deliver what the task or issue
  asks for.
- Do not add refactors, renames, cleanups, dependency upgrades, formatting
  passes, new features, or "while we are here" improvements that the task does
  not require.
- If you find something worth doing that is out of scope (a bug, tech debt, a
  missing feature), do **not** add it as a task. List it in a separate
  `Out of Scope` section at the end of the plan, one line per item, so the user
  can decide later.
- If completing the task genuinely requires touching something adjacent (for
  example a small refactor that makes the fix possible), include only the
  minimum needed and state in the task why it is required.

## Step 3: Design the Tests

Tests are a first-class part of the plan. Unless the user says otherwise:

### Coverage

- Plan tests that give excellent coverage of the new or changed behavior: the
  main path, edge cases, boundary values, invalid input, and error paths.
- Every task that changes behavior must follow test-driven development: write
  the failing test, run it and confirm it fails for the expected reason,
  implement, run it and confirm it passes.
- Every test must be written out in full in the plan, with the exact file path
  and the exact command to run it.

### Regression tests

- For a bug fix, plan at least one regression test that reproduces the bug. It
  must fail on the current code and pass after the fix.
- For a feature or change, plan regression tests for existing behavior that the
  change could break, when that behavior is not already covered by an existing
  test.

### No duplicate tests

Before planning any test, survey the existing test suite for the code being
changed. Then:

- Do not plan a test that asserts the same behavior as an existing test. If an
  existing test already covers a case, reference it by path and name instead of
  writing a new one. If an existing test must change because the behavior
  changes, plan a modification of that test, not a new copy.
- Do not plan two tests in the plan that assert the same behavior. Each test in
  the plan must cover something no other test (existing or planned) covers.
- A regression test and a coverage test must not duplicate each other. If one
  test serves both purposes, write it once.

## Step 4: Choose Where the Plan Is Stored

1. Look for a stated convention in the repository for where plans live (agent
   guidance files, contributor docs, or an existing tracked plans directory
   such as `docs/plans/` or `docs/superpowers/plans/`). If one exists, use it.
2. Otherwise, store the plan in `.superpowers/plans/`. This overrides the
   `docs/superpowers/plans/` default of `writing-plans`.
3. Name the file `YYYY-MM-DD-<short-task-name>.md`, using today's date. Include
   the issue number in the name when there is one, for example
   `2026-09-24-404-fix-broken-login.md`.

### Never commit plans by accident

A plan is committed **only** when the repository already has a directory of
committed plans (a plans directory whose files are tracked by git, which you can
check with `git ls-files <dir>`). In every other case the plan is local only:

- Do not `git add` or commit the plan file.
- `.superpowers/` is never committed. If `.superpowers/` is not already ignored
  (check with `git check-ignore .superpowers/`), add `.superpowers/` to
  `.git/info/exclude`, which is local and untracked. Do not edit `.gitignore`
  for this unless the user asks.
- The executing session must not commit the plan either. State this in the
  plan's `Global Constraints`.

## Step 5: Write the Plan

Follow the `writing-plans` format (header, `Global Constraints`,
`Review Focus`, file structure, bite-sized tasks with checkbox steps, no
placeholders, self-review), with these additions and overrides.

### Header additions

Add these lines to the plan header, after the fields required by
`writing-plans`:

```markdown
**Issue:** #<number> (or "none")

**Branch:** <branch the plan is executed on>
```

If the task has no separate spec document, set `**Spec:**` to the issue URL or
to "the task statement in this plan" and copy the task statement into a
`## Task Statement` section right after the header, so the executing session
has the full requirements.

### Global Constraints additions

Always include these lines in `Global Constraints`, in addition to the
constraints taken from the task, adjusted by any user override:

- Stay strictly within the scope of this plan. Do not implement anything listed
  under `Out of Scope`.
- Do not add tests that duplicate existing tests or other tests in this plan.
- Do not commit this plan file.
- Do not use `git worktree`. Work on the branch named in the header.

### Branch and worktree

- Plans are executed on the existing branch, never in a git worktree. This
  overrides any worktree guidance in `writing-plans` or other superpowers
  skills.
- At planning time, check the current branch. If its name fits the task, record
  it in the header. If it is the default branch (for example `main` or
  `master`), or it looks unrelated to the task, ask the user whether a new
  branch should be created and what it should be called. Record the answer in
  the header.
- The first task of the plan must verify that the executing session is on the
  recorded branch (and create it from the default branch if the user asked for
  a new branch that does not exist yet).

### Commits during execution

- Intermediate commits per task are fine and encouraged, as `writing-plans`
  describes. Use Conventional Commits messages.
- Do not push intermediate commits. Pushing happens only after the squash, so
  the squash never requires a force-push.

### Mandatory final tasks

The last tasks of every plan, in this order, unless the user says otherwise:

1. **Full verification.** Run the complete test suite, linters, formatters, and
   type checks the repository uses. Everything must pass.
2. **Squash.** Squash all commits made for this plan into a single commit that
   describes the task or issue solved, using
   [Conventional Commits](https://www.conventionalcommits.org). The commit body
   must summarize the change and must reference the issue it closes, for
   example `closes #404`. Write the exact commands in the plan, for example:

   ```bash
   git reset --soft "$(git merge-base HEAD origin/main)"
   git commit -m "fix(auth): reject expired session tokens" \
     -m "Expired tokens were accepted because the expiry check compared \
   against the token issue time instead of the current time. The check now \
   uses the current time and returns 401 for expired tokens." \
     -m "closes #404"
   ```

   Replace `origin/main` with the actual base branch. Omit the `closes` line
   only when the plan's header says `**Issue:** none`.

3. **Draft pull request.** Push the branch and open a **draft** pull request
   (for example `gh pr create --draft`). Never open a pull request that is
   ready for review. If a pull request conventions skill is installed, follow
   it. The pull request body must also reference the issue it closes.

## Step 6: Self-Review

Run the `writing-plans` self-review, then also check:

- **Scope:** every task is required by the task or issue. Anything else is
  moved to `Out of Scope`.
- **Tests:** new and changed behavior is covered, a regression test exists
  where required, and no planned test duplicates an existing test or another
  planned test.
- **Storage:** the plan is in the right location and will not be committed
  unless the repository commits plans.
- **Final tasks:** verification, squash with `closes #<number>`, and draft pull
  request are the last tasks.
- **Overrides:** every user override is recorded in `Global Constraints`.

Fix any problem inline.

## Step 7: Hand Off Without Executing

Never execute the plan, and never ask whether to execute it. This overrides the
"Execution Handoff" section of `writing-plans`: do not offer execution
approaches and do not ask which one to use.

Execution is always done by the user in a new, clean agent session. End by
telling the user:

- where the plan is saved;
- a short summary of its tasks;
- the items listed under `Out of Scope`, if any; and
- that the plan is ready to be executed in a clean session, for example by
  starting a new session and asking it to execute the plan at that path with
  `superpowers:executing-plans` or `superpowers:subagent-driven-development`.

Then ask the user to review the plan and wait for feedback. If the user asks for
changes, update the plan and hand off again the same way.
