# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a monorepo of **Claude Code skills** that enforce language-specific coding conventions. Each subdirectory is an independent skill package with its own README, LICENSE, and installation instructions. There is no build system, no test suite, and no application code — only skill definitions and supporting files.

## Repository Structure

| Directory | Skill(s) | Language/Target |
|-----------|----------|-----------------|
| `rust-conventions/` | `rust-conventions`, `fetch-rust-conventions` | Rust `.rs` files |
| `gleam-conventions/` | `gleam-conventions` | Gleam `.gleam` files |
| `cargo-toml-conventions/` | `cargo-toml-conventions` | `Cargo.toml` files |
| `js-conventions/` | `js-conventions` | JavaScript `.js`, `.mjs`, `.cjs`, `.jsx` files |
| `ts-conventions/` | `ts-conventions` | TypeScript `.ts`, `.tsx` files |

## How Skills Work

Each skill lives in a `<name>/<name>/SKILL.md` directory structure. The `SKILL.md` frontmatter (`name`, `description`) controls when Claude Code activates it. Skills reference guideline text files that contain the actual rules.

## Key Files

- **`rust-conventions/rust-conventions/rust-guidelines.txt`** — ~2500-line generated file from Microsoft's upstream mdBook. **Never hand-edit.** Updated via `bash rust-conventions/scripts/fetch-guidelines.sh`.
- **`rust-conventions/rust-conventions/custom-guidelines.txt`** — User-maintained `X-` prefix conventions. Never overwritten by the fetch script.
- **`gleam-conventions/gleam-conventions/conventions-patterns-anti-patterns.djot`** — Direct copy of the [official Gleam conventions document](https://github.com/gleam-lang/website/blob/main/documentation/conventions-patterns-anti-patterns.djot). **Never hand-edit.** Update by re-fetching from upstream (see Commands).
- **`js-conventions/js-conventions/js-guidelines.txt`** — Auto-fetched Airbnb JavaScript Style Guide. **Never hand-edit.** Updated via `bash js-conventions/scripts/fetch-guidelines.sh`.
- **`js-conventions/js-conventions/prettierrc.json`** — Prettier config derived from Airbnb conventions. Hand-maintained.
- **`js-conventions/js-conventions/eslint.config.js`** — ESLint 9 flat config using `eslint-config-airbnb-extended`. Hand-maintained.
- **`ts-conventions/ts-conventions/ts-guidelines.txt`** — Auto-fetched Google TypeScript Style Guide (HTML→Markdown). **Never hand-edit.** Updated via `bash ts-conventions/scripts/fetch-guidelines.sh`.

## Guideline Prefix Systems

- **Rust**: `M-` = Microsoft upstream (auto-generated), `X-` = custom extensions (manually maintained)
- **Gleam**: Uses the official Gleam conventions djot document directly (no prefix system — rules are organized by tier: Conventions, Patterns, Anti-patterns)
- **JavaScript**: `AIRBNB-` = Airbnb Style Guide (auto-fetched), rules identified by section number (e.g., `AIRBNB-2.1`)
- **TypeScript**: `GOOGLE-` = Google Style Guide (auto-fetched), rules identified by section anchor (e.g., `GOOGLE-IDENTIFIERS`)

## Commands

```bash
# Update Microsoft Rust guidelines from upstream
bash rust-conventions/scripts/fetch-guidelines.sh

# Update Airbnb JavaScript guidelines from upstream
bash js-conventions/scripts/fetch-guidelines.sh

# Update Google TypeScript guidelines from upstream
bash ts-conventions/scripts/fetch-guidelines.sh

# Update Gleam conventions from upstream
curl -sL https://raw.githubusercontent.com/gleam-lang/website/main/documentation/conventions-patterns-anti-patterns.djot \
  -o gleam-conventions/gleam-conventions/conventions-patterns-anti-patterns.djot
```

## Adding New Conventions

### New Rust `X-` convention

Add to `rust-conventions/rust-conventions/custom-guidelines.txt`:

```markdown
## Convention Name (X-MY-CONVENTION) { #X-MY-CONVENTION }

<why>Reason this convention exists.</why>
<version>1.0</version>

Description of the convention.
```

### New skill package

Follow the existing directory pattern: `<skill-name>/<skill-name>/SKILL.md` with a guideline text file alongside it. Add a `README.md` and `LICENSE` at the package root.
