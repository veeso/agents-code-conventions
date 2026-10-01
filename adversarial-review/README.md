# Adversarial Review

A coding agent skill that runs an adversarial review of changes. It decides
who should perform the review, prevents the agent from reviewing its own work,
and defines what every review must cover and how findings must be reported.

## What it enforces

| Rule                 | Description                                                                          |
| -------------------- | ------------------------------------------------------------------------------------ |
| Fresh reviewer       | An implementation-involved agent launches one full-tool, same-or-stronger reviewer   |
| No bias leakage      | The reviewer never receives author rationale, history, or suggested findings         |
| No duplicate reviews | An independent reviewer reviews directly instead of spawning another agent           |
| Intent and scope     | Every hunk is mapped to the stated intent; unrelated or missing work is flagged      |
| Tooling first        | Build, linter, formatter, and tests run; new warnings are findings                   |
| Lens checklist       | Every hunk is checked for correctness, errors, types, perf, docs, consistency, etc.  |
| Test audit           | Ineffective, missing, and repeated tests are reported                                |
| Verified findings    | Unverified claims go to Open questions, never into a severity bucket                 |
| Pedantic report      | Fixed template with Blocker, Major, Minor, Nit, Scope, and a per-file Coverage table |
| Verbatim relay       | Reviewer findings reach the user unsummarized and untouched                          |

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
