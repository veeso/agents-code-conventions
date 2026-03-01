# Cargo.toml Conventions for Claude Code

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that enforces consistent Cargo.toml formatting and structure across all Rust projects.

## What it enforces

| Rule | Description |
|------|-------------|
| Sorted dependencies | All `[*dependencies]` sections alphabetically ordered |
| `[package]` field order | name > version > edition > authors > description > license > repository |
| Section ordering | package > features > deps > dev-deps > build-deps > bin/lib > workspace |
| Sorted features | Feature names and their item lists alphabetically ordered |
| Workspace dependencies | Member crates use `workspace = true` instead of inline versions |
| Bare, shortest versions | No `^`/`~`/`=` prefix; `"1"` not `"1.0.0"` |
| Short form deps | `crate = "1"` not `crate = { version = "1" }` when only version is needed |
| Inline table key order | version > workspace > default-features > features > optional |
| `default-features = false` | Only when specifying `features` and defaults aren't needed |
| `dep:` syntax | Features enabling optional deps use `dep:crate_name` |

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/veeso/cargo-toml-conventions.git
```

### 2. Install the skill

Add the skill to your Claude Code configuration by adding the skill path to your project's `.claude/settings.json` (project-wide) or `~/.claude/settings.json` (global):

```json
{
  "skills": [
    "/absolute/path/to/cargo-toml-conventions/cargo-toml-conventions"
  ]
}
```

Or install for a single project by running from your project root:

```bash
claude mcp add-skill /absolute/path/to/cargo-toml-conventions/cargo-toml-conventions
```

### 3. Verify installation

Start a Claude Code session and ask it to edit a Cargo.toml file. The skill should activate automatically and enforce the conventions.

## License

[MIT](../LICENSE)
