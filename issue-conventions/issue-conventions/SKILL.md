---
name: issue-conventions
description: ALWAYS use this skill BEFORE opening an issue. Triggers whenever you are asked to open, create, file, or submit an issue (e.g. "open an issue", "create a bug report", "file a feature request"). Enforces how to create the issue with `gh issue create` and how to write a body that anyone can read, with no technical jargon, no AI dashes, and no AI arrows.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - git
    - github
    - issue
    - conventions
    - writing
---

# Issue Conventions

This skill governs how to open an issue and how to write its body so that
anyone can understand it.

## When to Use

- You are asked to open, create, file, or submit an issue
- You are asked to report a bug or request a feature
- You are preparing a problem report for a repository

## How to Open the Issue

Always create the issue with the GitHub CLI:

```bash
gh issue create --title "<title>" --body "<body>"
```

Pass the body inline or via `--body-file`. Do not open the issue through any
other mechanism unless the user asks for it.

## Rules

### 1. Never invent facts

Report only what the user gave you or what you can verify. Do not invent error
messages, version numbers, reproduction steps, or stack traces to "complete" the
issue. If something is unknown, leave it out or say it is unknown. A short,
honest issue is better than a detailed, made-up one.

### 2. Write the body for anyone

The issue body must be understandable by anyone, including people who do not
read code. Describe the problem or request in plain language. Avoid technical
jargon, internal names, and implementation detail that only the author would
recognise. If a technical term is unavoidable, explain it in one short sentence.

### 3. Write a clear, specific title

The title must say what the issue is in one line. Prefer a concrete summary over
a vague label. "Export button does nothing on the reports page" beats "Bug" or
"Export broken".

### 4. No AI dashes

Do not use the em dash (the long dash) or spaced dashes as connectors. Write
separate sentences, or use a comma, a colon, or parentheses instead.

```text
WRONG
The export fails — it times out after thirty seconds.

CORRECT
The export fails. It times out after thirty seconds.
```

### 5. No AI arrows

Do not use arrow characters to show flow, mapping, or steps. Write the relation
out in words.

```text
WRONG
Click Export -> wait -> nothing happens.

CORRECT
Click Export and wait. Nothing happens.
```

### 6. Use human language

Write the way a person would report a problem to a colleague. Short sentences,
plain words, no filler. Skip phrases like "this issue aims to" or "in order to".
Say what is wrong or what you want and why it matters.

### 7. Follow the repository issue template

Before writing the body, check the `.github` folder for an issue template. If
one exists, you must follow it: use its sections, headings, and order, and fill
in every part it asks for. The template wins over the default body templates
below.

Common template locations:

- `.github/ISSUE_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/` (a folder of named templates, often `.md` or `.yml`)

When the repository uses a template chooser, pick the template that matches the
kind of issue (bug, feature, question). The other rules still apply inside the
template: plain language, no em dashes, no arrows, no invented facts.

### 8. Always end with acceptance criteria

Every issue ends with an `## Acceptance criteria` section: a short checklist of
conditions that must all be true for the work to count as done. Write each one
as a checkbox (`- [ ] ...`), one condition per line, in plain language a
non-technical reader can verify. No internal names, no code detail.

How you write the criteria depends on what you have:

- **Reporting a problem** (a bug or a raw report): you do not know the fix yet, so
  do not invent one. Write the criteria as the correct behaviour the user should
  see once it is solved. Example: "Clicking Export downloads a file."
- **A refined task** (the scope and approach are already known): write concrete,
  checkable conditions for the work itself, in the order it gets done. Example:
  "The reports page has an Export button" and "The exported file opens in Excel".

If you cannot tell which case you are in, treat it as a report and describe the
behaviour the user wants, not the implementation.

### 9. Do not hard-wrap the body

Write each paragraph as a single unbroken line. Do not wrap the body at 80
characters (or any other width), and never end a line with trailing spaces to
force a break. GitHub re-flows paragraph text to the reader's window, so manual
wrapping shows up as a column of short, broken lines instead of one clean
paragraph. Only use a real blank line to separate paragraphs, and let list items
and headings sit on their own lines as normal.

```text
WRONG
The export button does nothing when clicked. It shows a spinner for a few
seconds and then stops, with no file and no error message anywhere on the
page.

CORRECT
The export button does nothing when clicked. It shows a spinner for a few seconds and then stops, with no file and no error message anywhere on the page.
```

## Default Body Template

Use this only when the repository has no issue template in `.github`.

The same structure covers both a problem report and a refined task. Fill in
`## Description` and `## Acceptance criteria` every time. Keep the optional
sections only when they add something, and delete the rest.

```markdown
## Description

What this is about, in plain words. What needs to happen and why it matters. For
a bug, say what happens now, how to make it happen, and what you expected
instead.

## Out of scope

Anything that is not part of this, to keep the work focused. Remove if not needed.

## Dependencies

Issues this depends on or is blocked by, and related issues. Use "Blocked by #123"
or "Related to #123". Remove if none.

## Notes

References, links, open questions, version, environment, or anything else that
helps. Remove if not needed.

## Acceptance criteria

- [ ] ...
- [ ] ...
```

See rule 8 for how to write the acceptance criteria depending on whether you are
reporting a problem or refining a task.

## Quick Reference

| Do                                 | Don't                               |
| ---------------------------------- | ----------------------------------- |
| Open with `gh issue create`        | Open via other tooling unprompted   |
| Plain language anyone can follow   | Jargon, internal names, code detail |
| Clear, specific title              | Vague titles like "Bug"             |
| Report only verified facts         | Invent errors, steps, or versions   |
| Separate sentences, commas, colons | Em dashes or spaced dashes          |
| Describe flow in words             | Arrow characters (`->`, `→`)        |
| Follow `.github` issue template    | Ignore an existing issue template   |
| End with acceptance criteria       | Ship an issue with no clear "done"  |
| AC as behaviour for a report       | Invent a fix you were not given     |
| One unbroken line per paragraph    | Hard-wrap the body at 80 chars      |

## Common Mistakes

- Filling in reproduction steps or error messages that the user never gave.
- Writing a vague title that does not say what the issue is.
- Using em dashes out of habit. Re-read the body and remove them.
- Using arrows to describe a sequence. Rewrite as a sentence.
- Writing a free-form body when the repository has an issue template to follow.
- Leaving out the acceptance criteria, so no one can tell when the work is done.
- Writing acceptance criteria as an invented fix when the issue is only a report.
  Describe the behaviour the user wants instead.
- Hard-wrapping the body at 80 characters, which GitHub renders as broken short
  lines instead of one flowing paragraph.
