# Adversarial Review

A coding agent skill that runs an adversarial review of changes. It decides
who should perform the review, prevents the agent from reviewing its own work,
and defines what every review must cover and how findings must be reported.

## What it enforces

| Rule                 | Description                                                                       |
| -------------------- | --------------------------------------------------------------------------------- |
| Fresh reviewer       | An implementation-involved agent must launch an independent reviewer              |
| No bias leakage      | The reviewer never receives author rationale, history, or suggested findings      |
| No duplicate reviews | An independent reviewer reviews directly instead of spawning another agent        |
| Bounded delegation   | Delegated review tasks must be narrow, distinct parts of the review surface       |
| Full scope           | Correctness, security, type safety, breaking changes, edge cases, tests, and docs |
| Actionable report    | One severity-ordered report with file and line evidence, impact, and a suggestion |
| Findings untouched   | Findings are presented to the user without being silently dismissed or fixed      |

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
request or the working tree. The skill should activate automatically, pick the
correct review mode, and return a severity-ordered report of findings.

## License

[MIT](./LICENSE)
