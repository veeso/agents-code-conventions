# Rust Conventions for Claude Code

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that enforces Rust coding guidelines when writing or modifying Rust code. It combines [Microsoft's Pragmatic Rust Guidelines](https://github.com/microsoft/rust-guidelines) with custom extensions.

## Convention prefixes

Guidelines use two prefixes to distinguish their origin:

| Prefix | Source | File | Example |
|--------|--------|------|---------|
| `M-` | [Microsoft Rust Guidelines](https://github.com/microsoft/rust-guidelines) | `rust-conventions/rust-guidelines.txt` | `M-CANONICAL-DOCS`, `M-PUBLIC-DEBUG` |
| `X-` | Custom extensions | `rust-conventions/custom-guidelines.txt` | `X-NO-MOD-RS` |

The `M-` conventions are synced from the upstream Microsoft repository. The `X-` conventions are maintained independently and are never overwritten by the fetch script.

The repo ships with `X-NO-MOD-RS`, which enforces using `module_name.rs` instead of the legacy `module_name/mod.rs` style for module organization.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/veeso/rust-conventions.git
```

### 2. Install the skills

Add the skills to your Claude Code project by adding the skill paths to your project's `.claude/settings.json` (project-wide) or `~/.claude/settings.json` (global):

```json
{
  "skills": [
    "/absolute/path/to/rust-conventions/rust-conventions",
    "/absolute/path/to/rust-conventions/fetch-conventions"
  ]
}
```

Or install for a single project by running from your project root:

```bash
claude mcp add-skill /absolute/path/to/rust-conventions/rust-conventions
claude mcp add-skill /absolute/path/to/rust-conventions/fetch-conventions
```

### 3. Verify installation

Start a Claude Code session and ask it to write some Rust code. The skill should activate automatically and enforce the guidelines.

## Updating Microsoft guidelines

To fetch the latest `M-` conventions from Microsoft's upstream repository:

```bash
bash scripts/fetch-guidelines.sh
```

Or invoke the `fetch-rust-conventions` skill inside a Claude Code session.

This only updates `rust-conventions/rust-guidelines.txt`. Your custom `X-` conventions in `rust-conventions/custom-guidelines.txt` are never modified.

## Adding custom conventions

Add your own conventions to `rust-conventions/custom-guidelines.txt` using the `X-` prefix:

```markdown
## My Custom Convention (X-MY-CONVENTION) { #X-MY-CONVENTION }

<why>Explanation of why this convention exists.</why>
<version>1.0</version>

Description of the convention and how to follow it.
```

## Skills included

| Skill | Name | Description |
|-------|------|-------------|
| `rust-conventions` | `rust-conventions` | Enforces Rust guidelines when writing/modifying `.rs` files |
| `fetch-conventions` | `fetch-rust-conventions` | Fetches and updates Microsoft guidelines from upstream |

## License

[MIT](LICENSE) - Microsoft guidelines are derived from [microsoft/rust-guidelines](https://github.com/microsoft/rust-guidelines) (MIT licensed).
