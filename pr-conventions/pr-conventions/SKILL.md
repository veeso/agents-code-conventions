---
name: pr-conventions
description: ALWAYS use this skill BEFORE opening a pull request. Triggers whenever you are asked to open, create, or submit a PR (e.g. "open a PR", "create a pull request", "submit this as a PR"). Enforces how to create the PR with `gh pr create` and how to write a PR body that anyone can read, with no technical jargon, no AI dashes, and no AI arrows.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - git
    - github
    - pull-request
    - conventions
    - writing
---

# Pull Request Conventions

This skill governs how to open a pull request and how to write its body so that
anyone can understand it.

## When to Use

- You are asked to open, create, or submit a pull request
- You are asked to push the current branch as a PR
- You are preparing a branch for review

## How to Open the PR

Always create the PR with the GitHub CLI:

```bash
gh pr create --title "<title>" --body "<body>"
```

Pass the body inline or via `--body-file`. Do not open the PR through any other
mechanism unless the user asks for it.

## Rules

### 1. Never write test cases

When opening a PR, do not add, generate, or write test cases as part of the
work. Open the PR with the changes the user already has. If tests are missing,
do not invent them to "complete" the PR.

### 2. Write the body for anyone

The PR body must be understandable by anyone, including people who do not read
code. Describe what changed and why in plain language. Avoid technical jargon,
internal names, and implementation detail that only the author would recognise.
If a technical term is unavoidable, explain it in one short sentence.

### 3. No AI dashes

Do not use the em dash (the long dash) or spaced dashes as connectors. Write
separate sentences, or use a comma, a colon, or parentheses instead.

```text
WRONG
This change speeds up the export — it now runs in the background.

CORRECT
This change speeds up the export. It now runs in the background.
```

### 4. No AI arrows

Do not use arrow characters to show flow, mapping, or steps. Write the relation
out in words.

```text
WRONG
Click Save -> the file uploads -> you get a confirmation.

CORRECT
When you click Save, the file uploads and you get a confirmation.
```

### 5. Use human language

Write the way a person would explain the change to a colleague. Short
sentences, plain words, no filler. Skip phrases like "this PR aims to" or "in
order to". Say what it does and why it matters.

### 6. Follow the repository PR template

Before writing the body, check the `.github` folder for a pull request
template. If one exists, you must follow it: use its sections, headings, and
order, and fill in every part it asks for. The template wins over the default
body template below.

Common template locations:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/PULL_REQUEST_TEMPLATE/` (a folder of named templates)

The other rules still apply inside the template: plain language, no em dashes,
no arrows, no invented test cases.

## Body Template

Use this only when the repository has no PR template in `.github`.

```markdown
## What changed

A short, plain description of what is different now.

## Why

The reason for the change and the problem it solves.

## Notes

Anything a reviewer should know before approving.
```

## Quick Reference

| Do                                 | Don't                               |
| ---------------------------------- | ----------------------------------- |
| Open with `gh pr create`           | Open via other tooling unprompted   |
| Plain language anyone can follow   | Jargon, internal names, code detail |
| Separate sentences, commas, colons | Em dashes or spaced dashes          |
| Describe flow in words             | Arrow characters (`->`, `→`)        |
| Leave tests as they are            | Write new test cases for the PR     |
| Follow `.github` PR template       | Ignore an existing PR template      |

## Common Mistakes

- Pasting the diff or commit list as the body instead of explaining the change.
- Using em dashes out of habit. Re-read the body and remove them.
- Using arrows to describe a sequence. Rewrite as a sentence.
- Adding test cases that the user never asked for.
- Writing a free-form body when the repository has a PR template to follow.
