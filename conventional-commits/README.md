# Conventional Commits

A coding agent skill that enforces the
[Conventional Commits](https://www.conventionalcommits.org) specification on
every commit, infers the commit type from the diff, and handles breaking changes,
reverts, and GPG signing.

## What it enforces

| Rule                | Description                                                          |
| ------------------- | ------------------------------------------------------------------- |
| Conventional format | `<type>[scope]: <description>` with optional body and footers       |
| Inferred type       | The type is chosen from the actual diff, never guessed              |
| Imperative present  | Descriptions read like "allow config to extend other configs"       |
| Breaking changes    | Marked with `!` and a `BREAKING CHANGE:` footer                     |
| Reverts             | `revert:` message with a `Refs:` footer of the reverted hash(es)    |
| GPG signing         | Signs with `-S` when enabled, reports failures, never pushes broken |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@conventional-commits

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@conventional-commits -g
```

This skill uses [`git`](https://git-scm.com). For GPG-signed commits, configure a
signing key and enable signing:

```bash
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true
```

### Verify installation

Start a coding agent session and ask it to commit a change. The skill should
activate automatically, write a Conventional Commits message with a type inferred
from the diff, and sign the commit when signing is enabled.

## License

[MIT](./LICENSE)
