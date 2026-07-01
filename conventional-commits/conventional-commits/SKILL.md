---
name: conventional-commits
description: ALWAYS use this skill BEFORE committing changes. Triggers whenever you are asked to commit, create a commit, or save changes to git (e.g. "commit this", "commit the changes", "make a commit"). Enforces the Conventional Commits format, infers the commit type from the diff, handles breaking changes and reverts, and ensures GPG-signed commits when signing is enabled.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - git
    - commit
    - conventional-commits
    - conventions
---

# Conventional Commits

This skill governs how to write commit messages and how to create commits. Every
commit you make must follow the [Conventional Commits](https://www.conventionalcommits.org)
specification.

## When to Use

- You are asked to commit changes, create a commit, or save work to git
- You are about to run `git commit`
- You are reverting a previous commit

## Message Format

Every commit message must follow this structure:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

The `type` must be one of the following:

| Type       | When to use                                                                       |
| ---------- | --------------------------------------------------------------------------------- |
| `feat`     | A new feature                                                                     |
| `fix`      | A bug fix                                                                         |
| `docs`     | Documentation only change                                                         |
| `style`    | Changes that don't affect the meaning or behaviour of the code                    |
| `refactor` | A change that neither fixes a bug nor adds a feature, focused on the architecture |
| `perf`     | A change that improves performance                                                |
| `test`     | Add missing tests or change existing tests                                        |
| `build`    | Bump dependencies or affect the build system                                      |
| `ci`       | Changes to CI configuration                                                       |
| `chore`    | Other changes that don't modify the source                                        |
| `revert`   | Revert a previous commit                                                          |

## Rules

### 1. Infer the type from the diff

Do not guess or default the type. Inspect the staged changes (`git diff --cached`)
and choose the type that matches what the change actually does. If the change adds
user-facing behaviour, it is `feat`. If it corrects broken behaviour, it is `fix`.
If it only moves or restructures code with no behaviour change, it is `refactor`.
Pick the single type that best describes the dominant change.

### 2. Write the description in the imperative present

The description must be an imperative present-tense sentence, as if completing
"This commit will ...". Do not capitalise the first letter beyond normal rules and
do not end with a period.

```text
WRONG
feat: added a config flag
feat: adds a config flag

CORRECT
feat: allow provided config object to extend other configs
```

### 3. Add a scope when it clarifies

Add an optional scope in parentheses when it tells the reader which part of the
code changed: `feat(parser): add ability to parse arrays`. Keep it short and
lowercase. Omit it when no single scope fits.

### 4. Breaking changes

When a commit introduces a breaking change, mark it in two ways:

1. Append a `!` after the type or scope: `feat!:` or `feat(api)!:`.
2. Add a `BREAKING CHANGE:` footer describing what breaks.

```text
feat(api)!: send an email to the customer when a product is shipped

BREAKING CHANGE: the response of the ship endpoint now returns the email id.
```

The `!` and the `BREAKING CHANGE:` footer must both be present for a breaking
change. Do not use one without the other.

### 5. Body and footers

Use the optional body to explain the *why* when it is not obvious from the
description. Separate the body from the description with one blank line. Footers
go after the body, each on its own line, in the `Token: value` form (for example
`Refs:`, `Reviewed-by:`, `BREAKING CHANGE:`).

### 6. Reverts

To revert a previous commit, use the `revert` type and reference the reverted
commit hash(es) in a `Refs:` footer:

```text
revert: let us never again speak of the noodle incident

Refs: 676104e, a215868
```

The description is the message of the commit being reverted.

### 7. GPG signing

If the repository or the user has GPG commit signing enabled, you must ensure the
commit is actually signed.

1. Detect whether signing is enabled:

   ```bash
   git config --get commit.gpgsign
   ```

   Treat signing as enabled when this returns `true`, or when the user has told
   you signing is required.

2. When signing is enabled, create the commit with `-S`:

   ```bash
   git commit -S -m "<message>"
   ```

If signing fails (no key, bad passphrase, agent locked), you MUST report the
failure to the caller with the exact error. Never push a commit when signing was
requested but failed, and never silently fall back to an unsigned commit.

## Workflow

1. Review the staged changes with `git diff --cached` (stage them first if needed).
2. Infer the correct `type` and optional `scope` from the diff.
3. Write an imperative-present description, plus body and footers as needed.
4. Mark breaking changes with `!` and a `BREAKING CHANGE:` footer.
5. Detect GPG signing and commit with `-S` when enabled; report any signing
   failure and do not push.

## Quick Reference

| Do                                            | Don't                                         |
| --------------------------------------------- | --------------------------------------------- |
| Infer the type from the actual diff           | Default to `chore` or guess the type          |
| Imperative present description                | Past tense or third person ("added", "adds")  |
| `feat!:` plus a `BREAKING CHANGE:` footer     | `!` without the footer, or footer without `!` |
| `revert:` with a `Refs:` footer of the hashes | A free-form revert message                    |
| Commit with `-S` when signing is enabled      | Silently fall back to an unsigned commit      |
| Report signing failures to the caller         | Push a commit that failed to sign             |

## Common Mistakes

- Defaulting to `chore` instead of reading the diff and inferring the real type.
- Writing the description in the past tense ("fixed the bug") instead of the
  imperative present ("fix the bug").
- Marking a breaking change with `!` but forgetting the `BREAKING CHANGE:` footer.
- Reverting without referencing the reverted commit hash in a `Refs:` footer.
- Creating an unsigned commit in a repository where signing is enabled.
- Pushing a commit after signing failed instead of reporting the failure.
