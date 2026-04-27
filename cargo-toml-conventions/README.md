# Cargo.toml Conventions

A coding agent skill that enforces consistent Cargo.toml formatting and structure across all Rust projects.

## What it enforces

| Rule                       | Description                                                               |
| -------------------------- | ------------------------------------------------------------------------- |
| Sorted dependencies        | All `[*dependencies]` sections alphabetically ordered                     |
| `[package]` field order    | name > version > edition > authors > description > license > repository   |
| Section ordering           | package > features > deps > dev-deps > build-deps > bin/lib > workspace   |
| Sorted features            | Feature names and their item lists alphabetically ordered                 |
| Workspace dependencies     | Member crates use `workspace = true` instead of inline versions           |
| Bare, shortest versions    | No `^`/`~`/`=` prefix; `"1"` not `"1.0.0"`                                |
| Short form deps            | `crate = "1"` not `crate = { version = "1" }` when only version is needed |
| Inline table key order     | version > workspace > default-features > features > optional              |
| `default-features = false` | Only when specifying `features` and defaults aren't needed                |
| `dep:` syntax              | Features enabling optional deps use `dep:crate_name`                      |

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@cargo-toml-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@cargo-toml-conventions -g
```

### Verify installation

Start a coding agent session and ask it to edit a Cargo.toml file. The skill should activate automatically and enforce the conventions.

## License

[MIT](../LICENSE)
