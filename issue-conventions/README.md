# Issue Conventions

A coding agent skill that controls how issues are opened and how their body is
written, so that anyone can understand the problem or request.

## What it enforces

| Rule                | Description                                                                                                          |
| ------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Open with `gh`      | Create every issue with `gh issue create`                                                                            |
| No invented facts   | Report only verified errors, steps, and versions                                                                     |
| Clear title         | A specific one-line summary, not a vague label                                                                       |
| Readable by anyone  | Plain language, no technical jargon                                                                                  |
| No AI dashes        | No em dashes or spaced dashes as connectors                                                                          |
| No AI arrows        | No arrow characters to show flow or steps                                                                            |
| Human language      | Short, plain sentences with no filler                                                                                |
| Acceptance criteria | End every issue with a checkable "done" list, written as behaviour for a report or concrete steps for a refined task |

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
activate automatically, create the issue with `gh issue create`, and write the
body in plain language with no AI dashes or arrows.

## License

[MIT](./LICENSE)
