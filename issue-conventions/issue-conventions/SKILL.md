---
name: issue-conventions
description: ALWAYS use this skill BEFORE opening an issue. Triggers whenever you are asked to open, create, file, or submit an issue (e.g. "open an issue", "create a bug report", "file a feature request"). Enforces `gh issue create` and short, jargon-free issues that anyone can follow in a refinement meeting, built around short acceptance criteria that state the expected end result.
license: MIT
metadata:
  author: veeso
  version: "2.0.0"
  tags:
    - git
    - github
    - issue
    - conventions
    - writing
---

# Issue Conventions

An issue must be readable in under a minute by anyone in a refinement meeting:
developers, product owners, designers, testers, or a newcomer. Short, plain,
and centered on the acceptance criteria.

## When to Use

- You are asked to open, create, file, or submit an issue
- You are asked to report a bug or request a feature
- You are preparing a problem report for a repository
- You are preparing a task for a refinement or planning session

## How to Open the Issue

```bash
gh issue create --title "<title>" --body "<body>"
```

Pass the body inline or via `--body-file`. Do not use other tooling unless the
user asks for it.

## Rules

### 1. No wall of text

The description is two to four short sentences. Say what is wrong or what is
wanted, and why it matters. Nothing else. If you need more than that, the
detail belongs in Notes, or the issue should be split.

- One idea per sentence
- No background story, no history of how the problem was found
- No bullet lists in the description unless they are reproduction steps
- If a sentence does not help someone decide or verify the work, cut it

### 2. No jargon

Write so that someone who does not read code understands every word. No
internal names, class names, function names, file paths, or acronyms the room
may not know. Describe what a person sees and does, not how the system works
inside.

```text
WRONG
The ReportExporter service throws on null tenantId in the CSV pipeline.

CORRECT
Exporting a report fails for some accounts. Nothing is downloaded.
```

If a technical term is truly unavoidable, explain it in a few words the first
time.

### 3. Acceptance criteria are the core

Every issue has an `## Acceptance criteria` section. This is the part people
read and discuss in refinement, so put the most care here.

Each criterion is:

- **One short sentence**, ideally under fifteen words
- **The end state**, written as a fact in the present tense: what is true once
  the work is done ("The report downloads as a file"), not a task ("Fix the
  export") or a wish ("It should work better")
- **About what someone sees or can do**, not about code or internals
- **Checkable by anyone**: a person can try it and answer yes or no
- **One outcome only**. If a criterion has "and" joining two outcomes, split it

```text
WRONG
- [ ] Refactor the export logic so tenantId is validated and handle nulls gracefully
- [ ] Improve export performance
- [ ] Export should work

CORRECT
- [ ] Clicking Export downloads the report as a file
- [ ] The file opens in Excel
- [ ] The export finishes in under ten seconds
- [ ] If the export fails, a message explains what went wrong
```

Keep the list small: usually three to six criteria. More than eight usually
means the issue should be split.

For a bug report, do not invent the fix. Write the criteria as the correct
behavior the user expects to see.

### 4. Clear, specific title

One line that says what the issue is. "Export button does nothing on the
reports page" beats "Bug" or "Export broken".

### 5. Never invent facts

Report only what the user gave you or what you can verify. Do not make up error
messages, versions, steps, or numbers. If something is unknown, leave it out.

### 6. Follow the repository issue template

Check `.github/ISSUE_TEMPLATE.md` and `.github/ISSUE_TEMPLATE/` first. If a
template exists, use its sections and order, and pick the one that matches the
kind of issue. All rules here still apply inside it.

### 7. No AI dashes, no AI arrows

No em dashes or spaced dashes as connectors. No arrow characters (`->`, `→`)
to show steps or flow. Write separate sentences, or use a comma or colon.

```text
WRONG
Click Export -> wait — nothing happens.

CORRECT
Click Export and wait. Nothing happens.
```

### 8. Do not hard-wrap the body

Write each paragraph as one unbroken line. GitHub re-flows text itself, so
manual wrapping shows up as broken short lines.

## Default Body Template

Use only when the repository has no issue template.

```markdown
## Description

Two to four short sentences. What is wrong or what is wanted, and why it matters.

## Acceptance criteria

- [ ] ...
- [ ] ...
- [ ] ...

## Out of scope

What this issue does not cover, one short line each. Remove if not needed.

## Notes

Links, related or blocking issues ("Blocked by #123"), version, environment. Remove if not needed.
```

## Example

```markdown
## Description

The Export button on the reports page does nothing. Users cannot share reports outside the app.

## Acceptance criteria

- [ ] Clicking Export downloads the report as a file
- [ ] The file opens in Excel
- [ ] If the export fails, a message explains what went wrong

## Out of scope

- Exporting to PDF
```

## Quick Reference

| Do                               | Don't                                |
| -------------------------------- | ------------------------------------ |
| Open with `gh issue create`      | Open via other tooling unprompted    |
| Two to four sentence description | Walls of text, background stories    |
| Words anyone in the room knows   | Jargon, internal names, code detail  |
| AC as short end-state facts      | AC as tasks, wishes, or internals    |
| One outcome per criterion        | Criteria joining several outcomes    |
| Three to six criteria            | Long lists (split the issue instead) |
| Clear, specific title            | Vague titles like "Bug"              |
| Report only verified facts       | Invent errors, steps, or versions    |
| Follow `.github` issue template  | Ignore an existing issue template    |
| Sentences, commas, colons        | Em dashes, spaced dashes, arrows     |
| One unbroken line per paragraph  | Hard-wrap the body                   |

## Before Submitting

Read the issue as if you were a non-technical person in a refinement meeting.

- Can you say what this issue is about after reading only the title and
  description?
- Can you check every acceptance criterion by trying the product, without
  reading code?
- Is there any sentence you could delete without losing meaning? Delete it.
