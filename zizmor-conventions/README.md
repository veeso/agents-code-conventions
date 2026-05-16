# zizmor Conventions

A coding agent skill that enforces secure GitHub Actions authoring and validates
every change with [zizmor](https://docs.zizmor.sh), a static analysis tool for
GitHub Actions.

## What it enforces

| Rule                          | Description                                                     |
| ----------------------------- | --------------------------------------------------------------- |
| SHA-pinned actions            | Third-party `uses:` pinned to full commit SHA with version note |
| Least-privilege permissions   | Explicit `permissions:`, default `contents: read`               |
| No template injection         | Untrusted `${{ }}` routed via `env:`, not inlined into `run:`   |
| Safe triggers                 | No checkout/exec of untrusted refs under privileged triggers    |
| Credential hygiene            | `persist-credentials: false`, no hardcoded container creds      |
| Trusted publishing            | OIDC instead of long-lived publish tokens                       |
| Narrow secret scope           | No `secrets: inherit`, no over-provisioned secrets              |
| Self-hosted runner safety     | No untrusted code on self-hosted runners                        |
| Action authenticity           | No impostor commits or known-vulnerable action versions         |
| Mandatory zizmor verification | Run zizmor after every change, loop until zero findings         |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@zizmor-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@zizmor-conventions -g
```

This skill calls the [`zizmor`](https://docs.zizmor.sh) CLI. Install it with one
of:

```bash
uv tool install zizmor
pipx install zizmor
brew install zizmor
cargo install zizmor
```

### Verify installation

Start a coding agent session and ask it to edit a workflow under
`.github/workflows/`. The skill should activate automatically, enforce the
conventions, and run zizmor until the workflow is clean.

## License

[MIT](./LICENSE)
