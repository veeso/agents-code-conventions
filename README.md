# Agents Code Conventions

![claude](https://img.shields.io/badge/Claude-D97757?style=for-the-badge&logo=claude&logoColor=white)
![rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)
![gleam](https://img.shields.io/badge/Gleam-ffaff3?style=for-the-badge&logo=gleam&logoColor=white)

A collection of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills that enforce language-specific coding conventions. Install them into your Claude Code environment and they activate automatically when you write or modify code in a supported language.

## Available Skills

| Skill | Target | Description |
|-------|--------|-------------|
| [rust-conventions](./rust-conventions/) | `.rs` files | Enforces [Microsoft Rust Guidelines](https://github.com/microsoft/rust-guidelines) (`M-` prefix) and custom extensions (`X-` prefix) |
| [gleam-conventions](./gleam-conventions/) | `.gleam` files | Enforces idiomatic Gleam conventions (`G-` prefix) derived from major Gleam projects and official docs |
| [cargo-toml-conventions](./cargo-toml-conventions/) | `Cargo.toml` | Enforces consistent formatting, dependency sorting, section ordering, and version conventions |

## Installation

### Global install (all projects)

Add skill paths to `~/.claude/settings.json`:

```json
{
  "skills": [
    "/absolute/path/to/agents-code-conventions/rust-conventions/rust-conventions",
    "/absolute/path/to/agents-code-conventions/rust-conventions/fetch-conventions",
    "/absolute/path/to/agents-code-conventions/gleam-conventions/gleam-conventions",
    "/absolute/path/to/agents-code-conventions/cargo-toml-conventions/cargo-toml-conventions"
  ]
}
```

### Per-project install

Add skill paths to your project's `.claude/settings.json`, or use the CLI:

```bash
claude mcp add-skill /absolute/path/to/agents-code-conventions/rust-conventions/rust-conventions
claude mcp add-skill /absolute/path/to/agents-code-conventions/gleam-conventions/gleam-conventions
claude mcp add-skill /absolute/path/to/agents-code-conventions/cargo-toml-conventions/cargo-toml-conventions
```

You don't need to install all skills — pick only the ones relevant to your project.

### Verify

Start a Claude Code session and run `/skills`. Installed skills should appear in the list. Ask Claude to write code in a supported language and it will follow the conventions automatically.

## How It Works

Each skill consists of a `SKILL.md` file (which tells Claude Code when to activate and what to do) and one or more guideline text files containing the actual rules. When Claude detects that you're working with a matching file type, it reads the guidelines and enforces them on all code it writes or modifies.

```
<skill-name>/
├── README.md
├── LICENSE
└── <skill-name>/
    ├── SKILL.md              # Skill definition (name, description, instructions)
    └── <lang>-guidelines.txt  # Convention rules with prefixed IDs
```

## Guideline Systems

Each skill uses prefixed IDs so individual rules can be referenced unambiguously:

| Skill | Prefix | Source |
|-------|--------|--------|
| rust-conventions | `M-` | Auto-synced from [microsoft/rust-guidelines](https://github.com/microsoft/rust-guidelines) |
| rust-conventions | `X-` | Custom extensions, manually maintained |
| gleam-conventions | `G-` | Derived from official Gleam docs and major projects |

### Updating Rust `M-` guidelines

The Microsoft guidelines can be refreshed from upstream:

```bash
bash rust-conventions/scripts/fetch-guidelines.sh
```

This regenerates `rust-conventions/rust-conventions/rust-guidelines.txt` without touching the custom `X-` conventions in `custom-guidelines.txt`.

### Adding custom Rust conventions

Add new `X-` rules to `rust-conventions/rust-conventions/custom-guidelines.txt`:

```markdown
## Convention Name (X-MY-CONVENTION) { #X-MY-CONVENTION }

<why>Reason this convention exists.</why>
<version>1.0</version>

Description of the convention.
```

## License

[MIT](LICENSE)
