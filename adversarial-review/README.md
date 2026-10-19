# Adversarial Review

A coding agent skill that runs an adversarial review of changes as a loop of
review and fix rounds. Independent agents review and fix the change until a
review comes back clean or the round limit is reached, then all fixes are
squashed into the reviewed commit. It also defines what every review must
cover and how findings must be reported.

## What it enforces

| Rule               | Description                                                                               |
| ------------------ | ----------------------------------------------------------------------------------------- |
| Review loop        | Review, fix, and commit `fix: review round N` until clean or 5 rounds (configurable)      |
| Independent agents | A fresh full-tool reviewer and fixer per round, on the strongest model at medium effort   |
| No bias leakage    | Reviewers never receive author rationale, history, earlier reports, or suggested findings |
| Strict scope       | Findings and fixes stay within the issue, ticket, or task unless the user says otherwise  |
| Squash at the end  | All review round commits are squashed into the reviewed commit; nothing is pushed         |
| Intent and scope   | Every hunk is mapped to the stated intent; unrelated or missing work is flagged           |
| Tooling first      | Build, linter, formatter, and tests run; new warnings are findings                        |
| Lens checklist     | Every hunk is checked for correctness, errors, types, perf, docs, consistency, etc.       |
| Test audit         | Ineffective, missing, and repeated tests are reported                                     |
| Verified findings  | Unverified claims are dropped; the report never asks questions                            |
| Pedantic report    | Fixed template with Blocker, Major, Minor, Nit, and Scope                                 |
| Verbatim relay     | Skipped and remaining findings reach the user unsummarized                                |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@adversarial-review

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@adversarial-review -g
```

### Verify installation

Start a coding agent session and ask for an adversarial review of a pull
request or a branch. The skill should activate automatically, run review and
fix rounds with independent agents, squash the fixes into the reviewed commit,
and report how the loop ended.

## License

[MIT](./LICENSE)
