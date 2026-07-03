---
name: pr-conventions
description: ALWAYS use this skill BEFORE opening a pull request. Triggers whenever you are asked to open, create, or submit a PR (e.g. "open a PR", "create a pull request", "submit this as a PR"). Enforces `gh pr create`, Conventional Commit PR titles, and PR bodies anyone can read, with no technical jargon, no AI dashes, and no AI arrows.
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

The PR title must use the same Conventional Commit syntax as the commit message
subject. If a commit message subject is `feat(scope): add thing`, the PR title
must be `feat(scope): add thing`.

This rule overrides every other PR creation helper, including `github:yeet`.
Never add, preserve, or allow an agent prefix in the title. `[codex]` is
forbidden in any position, with any capitalization. If a tool proposes a title
containing `[codex]`, discard that title and pass the correct Conventional
Commit title explicitly with `gh pr create --title`.

Before running `gh pr create`, validate the title yourself. If the title is not
the commit message subject in Conventional Commit format, or if it contains
`[codex]`, stop and fix the title before creating the PR. If you cannot identify
the commit message subject, stop and ask the user for the exact title.

## Rules

### 1. Use the Conventional Commit title

The title must be the Conventional Commit subject used for the commit message.
Do not add extra prefixes, labels, suffixes, emoji, or agent markers.
This is a fail-closed rule: if the title is not clearly correct, do not open the
PR until it is fixed.

Forbidden examples:

- `[codex] feat: add export`
- `feat: add export [codex]`
- `Codex: feat: add export`

Correct example:

- `feat: add export`

### 2. Never write test cases

When opening a PR, do not add, generate, or write test cases as part of the
work. Open the PR with the changes the user already has. If tests are missing,
do not invent them to "complete" the PR.

### 3. Write the body for anyone

The PR body must be understandable by anyone, including people who do not read
code. Describe what changed and why in plain language. Avoid technical jargon,
internal names, and implementation detail that only the author would recognise.
If a technical term is unavoidable, explain it in one short sentence.

### 4. No AI dashes

Do not use the em dash (the long dash) or spaced dashes as connectors. Write
separate sentences, or use a comma, a colon, or parentheses instead.

```text
WRONG
This change speeds up the export — it now runs in the background.

CORRECT
This change speeds up the export. It now runs in the background.
```

### 5. No AI arrows

Do not use arrow characters to show flow, mapping, or steps. Write the relation
out in words.

```text
WRONG
Click Save -> the file uploads -> you get a confirmation.

CORRECT
When you click Save, the file uploads and you get a confirmation.
```

### 6. Use human language

Write the way a person would explain the change to a colleague. Short
sentences, plain words, no filler. Skip phrases like "this PR aims to" or "in
order to". Say what it does and why it matters.

### 7. Follow the repository PR template

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

### 8. Do not hard-wrap the body

Write each paragraph as a single unbroken line. Do not wrap the body at 80
characters (or any other width), and never end a line with trailing spaces to
force a break. GitHub re-flows paragraph text to the reader's window, so manual
wrapping shows up as a column of short, broken lines instead of one clean
paragraph. Only use a real blank line to separate paragraphs, and let list
items and headings sit on their own lines as normal.

```text
WRONG
The export now runs in the background. It no longer blocks the page while
it works, so you can keep using the app and get a notification when the
file is ready.

CORRECT
The export now runs in the background. It no longer blocks the page while it works, so you can keep using the app and get a notification when the file is ready.
```

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

| Do                                        | Don't                               |
| ----------------------------------------- | ----------------------------------- |
| Use the Conventional Commit subject title | Add `[codex]` or any agent marker   |
| Open with `gh pr create`                  | Open via other tooling unprompted   |
| Plain language anyone can follow          | Jargon, internal names, code detail |
| Separate sentences, commas, colons        | Em dashes or spaced dashes          |
| Describe flow in words                    | Arrow characters (`->`, `→`)        |
| Leave tests as they are                   | Write new test cases for the PR     |
| Follow `.github` PR template              | Ignore an existing PR template      |
| One unbroken line per paragraph           | Hard-wrap the body at 80 chars      |

## Common Mistakes

- Letting a PR helper add `[codex]` or another agent marker to the title.
- Changing the title away from the commit message's Conventional Commit subject.
- Pasting the diff or commit list as the body instead of explaining the change.
- Using em dashes out of habit. Re-read the body and remove them.
- Using arrows to describe a sequence. Rewrite as a sentence.
- Adding test cases that the user never asked for.
- Writing a free-form body when the repository has a PR template to follow.
- Hard-wrapping the body at 80 characters, which GitHub renders as broken
  short lines instead of one flowing paragraph.
