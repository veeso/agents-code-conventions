# Issue Conventions

A coding agent skill that controls how issues are opened and how their body is
written: short, jargon-free, and ready to discuss in a refinement meeting with
anyone in the room.

## What it enforces

| Rule                   | Description                                                         |
| ---------------------- | ------------------------------------------------------------------- |
| Open with `gh`         | Create every issue with `gh issue create`                           |
| No wall of text        | Description of two to four short sentences                          |
| No jargon              | Words anyone in a refinement meeting understands                    |
| Acceptance criteria    | Short, checkable sentences stating the end result, one outcome each |
| Clear title            | A specific one-line summary, not a vague label                      |
| No invented facts      | Report only verified errors, steps, and versions                    |
| Issue templates        | Follow the repository template when one exists                      |
| No AI dashes or arrows | No em dashes, spaced dashes, or arrow characters                    |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@issue-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@issue-conventions -g
```

This skill uses the [`gh`](https://cli.github.com) GitHub CLI. Install and
authenticate it first:

```bash
brew install gh
gh auth login
```

### Verify installation

Start a coding agent session and ask it to open an issue. The skill should
activate automatically, create the issue with `gh issue create`, and write a
short body in plain language that ends with short acceptance criteria.

## License

[MIT](./LICENSE)
