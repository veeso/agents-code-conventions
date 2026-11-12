# Rebase

A coding agent skill that rebases the current branch onto the default branch
(or a branch you choose), resolves every conflict so the work of both sides is
kept, verifies the result, and force pushes with lease.

## What it does

| Step            | Description                                                                         |
| --------------- | ----------------------------------------------------------------------------------- |
| Start or resume | Fetches and rebases onto `origin/<default>` or continues the rebase in progress     |
| Safety net      | Requires a clean tree and saves a `backup/<branch>-<timestamp>` ref before starting |
| Resolve         | Reads why each side changed the code and combines both changes                      |
| Ask sparingly   | Asks you only when the two sides truly exclude each other                           |
| Lockfiles       | Regenerates lockfiles and generated files instead of hand-merging them              |
| Verify          | Checks for leftover markers, compares with `git range-diff`, runs build and tests   |
| Push            | Pushes with `--force-with-lease --force-if-includes`, never a bare `--force`        |

## Usage

```text
/rebase              # rebase onto the default branch of origin
/rebase develop      # rebase onto origin/develop
/rebase upstream/main
```

It also activates when you ask to "rebase" or to "resolve conflicts" during a
rebase.

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@rebase

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@rebase -g
```

This skill uses [`git`](https://git-scm.com) and, optionally,
[`gh`](https://cli.github.com) to read the default branch and PR description.

### Verify installation

Start a coding agent session on a branch behind its base and run `/rebase`.
The skill should fetch the base, rebase, resolve any conflict, run the
project's checks, and push with lease.

## License

[MIT](./LICENSE)
