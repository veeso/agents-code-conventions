# Plan Implementation

A coding agent skill that writes implementation plans for tasks, features, bug
fixes, and issues. It builds on the
[superpowers](https://github.com/obra/superpowers) `writing-plans` skill and
adds rules for scope, testing, plan storage, git history, and handoff.

## What it enforces

| Rule                   | Description                                                                         |
| ---------------------- | ----------------------------------------------------------------------------------- |
| Superpowers required   | Checks the superpowers suite is installed and flags any missing skill               |
| Strict scope           | Only tasks required by the task or issue; everything else goes to `Out of Scope`    |
| Full test coverage     | Test-first tasks covering main paths, edge cases, and error paths                   |
| Regression tests       | A failing reproduction for bug fixes and protection for behavior the change touches |
| No duplicate tests     | No test repeats an existing test or another test in the plan                        |
| Plan location          | `.superpowers/plans/` unless the repository states a different convention           |
| Plans stay local       | Plans are committed only when the repository already commits plans                  |
| No worktrees           | Plans run on the current branch; asks before planning on the default branch         |
| Single squashed commit | Final step squashes everything into one Conventional Commit with `closes #<issue>`  |
| Draft pull request     | The pull request opened at the end is always a draft                                |
| No execution           | Never executes the plan or asks to; execution happens in a clean session            |
| User overrides         | Any rule can be overridden by the user and is recorded in the plan                  |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@plan-implementation

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@plan-implementation -g
```

This skill requires the [superpowers](https://github.com/obra/superpowers)
skill suite. In Claude Code:

```text
/plugin install superpowers@claude-plugins-official
```

### Verify installation

Start a coding agent session and ask it to plan the implementation of an issue.
The skill should activate automatically, check the superpowers suite, write the
plan to `.superpowers/plans/`, and stop without executing it.

## License

[MIT](./LICENSE)
