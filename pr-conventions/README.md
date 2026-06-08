# PR Conventions

A coding agent skill that controls how pull requests are opened and how their
description is written, so that anyone can understand the change.

## What it enforces

| Rule               | Description                                              |
| ------------------ | -------------------------------------------------------- |
| Open with `gh`     | Create every PR with `gh pr create`                      |
| No test cases      | Do not add or write test cases as part of opening the PR |
| Readable by anyone | Plain language, no technical jargon                      |
| No AI dashes       | No em dashes or spaced dashes as connectors              |
| No AI arrows       | No arrow characters to show flow or steps                |
| Human language     | Short, plain sentences with no filler                    |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@pr-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@pr-conventions -g
```

This skill uses the [`gh`](https://cli.github.com) GitHub CLI. Install and
authenticate it first:

```bash
brew install gh
gh auth login
```

### Verify installation

Start a coding agent session and ask it to open a pull request. The skill
should activate automatically, create the PR with `gh pr create`, and write the
body in plain language with no AI dashes or arrows.

## License

[MIT](./LICENSE)
