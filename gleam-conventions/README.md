# Gleam Conventions

![gleam](https://img.shields.io/badge/Gleam-ffaff3?style=for-the-badge&logo=gleam&logoColor=white)

A coding agent skill that enforces idiomatic Gleam coding conventions when writing or modifying `.gleam` files. The skill uses the [official Gleam conventions, patterns, and anti-patterns document](https://github.com/gleam-lang/website/blob/main/documentation/conventions-patterns-anti-patterns.djot) directly from the Gleam project.

## What it does

When activated, the skill instructs the agent to follow the official Gleam conventions document (`conventions-patterns-anti-patterns.djot`) before writing or modifying any Gleam code. The document is organized into three tiers:

- **Conventions** (Mandatory) — Rules that must be adhered to always
- **Patterns** (Recommended) — Idiomatic approaches to apply when beneficial
- **Anti-patterns** (Avoid) — Known pitfalls that should never be introduced

### Conventions

| Rule                                                         |
| ------------------------------------------------------------ |
| Avoid unqualified importing of functions and constants       |
| Annotate all module functions                                |
| Use result for fallible functions                            |
| Use singular for module names                                |
| Treat acronyms as single words                               |
| Conventional conversion function naming (`x_to_y`)           |
| Conventional fallible function naming (`try_` prefix)        |
| Use the core libraries                                       |
| Keep development tool config in `gleam.toml`                 |
| Use the correct source code directory (`src`, `dev`, `test`) |

### Patterns

| Pattern                         |
| ------------------------------- |
| Design descriptive errors       |
| Comment liberally               |
| Make invalid states impossible  |
| Replace bools with custom types |
| The sans-io pattern             |
| The builder pattern             |

### Anti-patterns

| Anti-pattern               |
| -------------------------- |
| Abbreviations              |
| Fragmented modules         |
| Panicking in libraries     |
| Global namespace pollution |
| Namespace trespassing      |
| Grouping by design pattern |
| Check-then-assert          |
| Using dynamic with FFI     |
| Match all variants         |
| Category theory overuse    |

## Updating the guidelines

The guidelines file is a direct copy of the upstream djot file from the Gleam website repository. To update it:

```bash
curl -sL https://raw.githubusercontent.com/gleam-lang/website/main/documentation/conventions-patterns-anti-patterns.djot \
  -o gleam-conventions/conventions-patterns-anti-patterns.djot
```

## Install

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@gleam-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@gleam-conventions -g
```

### Verify installation

After installing, start a coding agent session and verify the skill is loaded. You can verify it's working by asking the agent to write a simple Gleam function — it should follow the guidelines automatically.

## License

This project is licensed under the MIT LICENSE. Read the full [LICENSE](./LICENSE).
