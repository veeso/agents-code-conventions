---
name: cargo-toml-conventions
description: Use when creating or modifying any Cargo.toml file. Enforces dependency sorting, section ordering, workspace dependency usage, and version format conventions. MANDATORY for all Cargo.toml edits.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - rust
    - cargo
    - conventions
---

# Cargo.toml Conventions

Enforces consistent Cargo.toml formatting and structure across all Rust projects.

## When to Use

- Creating a new Cargo.toml
- Adding, removing, or modifying dependencies
- Editing any section of an existing Cargo.toml

## Rules

### 1. Dependencies Must Be Sorted Alphabetically

All dependency entries within `[dependencies]`, `[dev-dependencies]`, and `[build-dependencies]` MUST be sorted alphabetically by crate name.

```toml
# WRONG
[dependencies]
tokio = { version = "1", features = ["full"] }
serde = "1"
anyhow = "1"

# CORRECT
[dependencies]
anyhow = "1"
serde = "1"
tokio = { version = "1", features = ["full"] }
```

This also applies to `workspace.dependencies` in workspace root Cargo.toml files.

### 2. `[package]` Field Ordering

Fields within `[package]` MUST appear in this order (omit fields that don't apply):

```toml
[package]
name = "my-crate"
version = "0.1"
edition = "2021"
authors = ["Alice <alice@example.com>"]
description = "A short description"
license = "MIT"
repository = "https://github.com/user/repo"
# ... remaining fields alphabetically
```

**`edition` is mandatory** — always specify it explicitly, never rely on the implicit default.

### 3. Section Ordering

Sections MUST appear in this order (omit sections that don't apply):

1. `[package]`
2. `[features]`
3. `[dependencies]`
4. `[dev-dependencies]`
5. `[build-dependencies]`
6. `[[bin]]` / `[lib]`
7. `[workspace]`

### 4. Feature Entries Sorted Alphabetically

Feature names in `[features]` MUST be sorted alphabetically. Items within each feature list MUST also be sorted.

```toml
# WRONG
[features]
full = ["tls", "json", "async"]
default = ["json"]
async = ["dep:tokio"]

# CORRECT
[features]
async = ["dep:tokio"]
default = ["json"]
full = ["async", "json", "tls"]
```

### 5. Use Workspace Dependencies

When inside a Cargo workspace, crates MUST use workspace-level dependency declarations.

**Workspace root `Cargo.toml`:** declare shared dependencies under `[workspace.dependencies]`.

```toml
[workspace.dependencies]
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
```

**Member crate `Cargo.toml`:** reference with `workspace = true`.

```toml
[dependencies]
serde = { workspace = true }
tokio = { workspace = true }
```

If a member crate needs extra features beyond the workspace declaration, add them locally:

```toml
[dependencies]
tokio = { workspace = true, features = ["test-util"] }
```

### 6. Version Format

Use **bare versions** (no prefix symbol). Do NOT use `^`, `~`, or `=` prefixes.

Prefer the **shortest version specifier** possible. Drop trailing `.0` segments unless a minimum minor or patch version is actually required.

```toml
# WRONG
serde = "^1.0"
tokio = "~1.38"
anyhow = "=1.0.86"
serde_json = "1.0"       # unnecessary .0
my-crate = "0.8.0"       # unnecessary .0

# CORRECT
serde = "1"              # any 1.x.x
tokio = "1.38"           # needs >= 1.38 for a specific feature
anyhow = "1"             # any 1.x.x
serde_json = "1"         # any 1.x.x
my-crate = "0.8"         # any 0.8.x
```

Exception: `=` is acceptable when an exact pin is genuinely required (e.g., matching a proc-macro to its companion crate). Add a comment explaining why.

### 7. Simple Dependencies Use Short Form

When a dependency has only a version (no features, no optional flag), use the short string form.

```toml
# WRONG
serde_json = { version = "1" }

# CORRECT
serde_json = "1"
serde = { version = "1", features = ["derive"] }  # needs inline table for features
```

### 8. Inline Table Key Ordering

When a dependency uses an inline table, keys MUST appear in this order:

- For workspace deps: `workspace` > `default-features` > `features` > `optional`
- For versioned deps: `version` > `workspace` > `default-features` > `features` > `optional`

```toml
# WRONG
serde = { features = ["derive"], version = "1" }
tokio = { optional = true, version = "1", features = ["full"] }

# CORRECT
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"], optional = true }
my-lib = { workspace = true, features = ["extra"] }
```

### 9. `default-features = false` When Selecting Features

When specifying `features = [...]` and you don't need the crate's default features, explicitly set `default-features = false`. Only add this flag when you are specifying features — do not add it to deps that use defaults as-is.

If a crate provides default features you're not using, consider enabling only what you need with `default-features = false` plus an explicit `features` list.

```toml
# CORRECT — selecting specific features, disabling defaults
tokio = { version = "1", default-features = false, features = ["rt", "macros"] }

# CORRECT — using defaults, no need for default-features
serde = "1"
```

### 10. Use `dep:` Syntax for Optional Dependencies in Features

When a feature enables an optional dependency, use `dep:crate_name` to avoid implicitly creating a feature with the crate's name.

```toml
# WRONG
[features]
tls = ["native-tls"]

[dependencies]
native-tls = { version = "0.2", optional = true }

# CORRECT
[features]
tls = ["dep:native-tls"]

[dependencies]
native-tls = { version = "0.2", optional = true }
```

## Quick Reference

| Rule | Check |
|------|-------|
| Deps sorted | Each `[*dependencies]` section is alphabetical |
| `[package]` fields | name > version > edition > authors > description > license > repository > rest |
| Section order | package > features > deps > dev-deps > build-deps > bin/lib > workspace |
| Features sorted | Feature names and their item lists are alphabetical |
| Workspace deps | Member crates use `workspace = true`, not inline versions |
| Bare versions | No `^` / `~` / `=` prefix; use shortest specifier (`"1"` not `"1.0.0"`) |
| Short form | `crate = "1"` not `crate = { version = "1" }` when only version is needed |
| Key order | version > workspace > default-features > features > optional |
| `default-features` | Set `false` only when specifying `features` and defaults aren't needed |
| `dep:` syntax | Features enabling optional deps use `dep:crate_name` |

## Common Mistakes

- Appending new dependencies at the end instead of inserting in sorted position
- Duplicating a workspace dependency version in a member crate instead of using `workspace = true`
- Using `^` prefix out of habit (it's the default and redundant)
- Omitting `edition` from `[package]`
- Using `{ version = "1" }` inline table when the short form `"1"` suffices
- Enabling optional deps in features without `dep:` prefix (leaks implicit feature names)
- Putting `features` before `version` in inline tables
- Adding `default-features = false` on a dependency that doesn't specify `features`
