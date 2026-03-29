# Agents Code Conventions

![rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)
![gleam](https://img.shields.io/badge/Gleam-ffaff3?style=for-the-badge&logo=gleam&logoColor=white)
![javascript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![typescript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![markdown](https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white)

A collection of coding agent skills that enforce language-specific coding conventions. Install them into your agent environment (e.g. [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Gemini CLI](https://github.com/google-gemini/gemini-cli), [OpenAI Codex](https://github.com/openai/codex)) and they activate automatically when the agent writes or modifies code in a supported language.

## Available Skills

| Skill | Target | Description |
|-------|--------|-------------|
| [rust-conventions](./rust-conventions/) | `.rs` files | Enforces [Microsoft Rust Guidelines](https://github.com/microsoft/rust-guidelines) (`M-` prefix) and custom extensions (`X-` prefix) |
| [gleam-conventions](./gleam-conventions/) | `.gleam` files | Enforces idiomatic Gleam conventions from the official Gleam conventions document |
| [cargo-toml-conventions](./cargo-toml-conventions/) | `Cargo.toml` | Enforces consistent formatting, dependency sorting, section ordering, and version conventions |
| [js-conventions](./js-conventions/) | `.js`, `.mjs`, `.cjs`, `.jsx` files | Enforces [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) (`AIRBNB-` prefix) |
| [ts-conventions](./ts-conventions/) | `.ts`, `.tsx` files | Enforces [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) (`GOOGLE-` prefix) |
| [md-conventions](./md-conventions/) | `.md` files | Enforces [markdownlint](https://github.com/DavidAnson/markdownlint) rules (`MD-` prefix) |

## Installation

Skills can be installed with [`npx skills`](https://github.com/vercel-labs/skills):

### Install all skills

```bash
npx skills add veeso/agents-code-conventions
```

### Install a specific skill

```bash
npx skills add veeso/agents-code-conventions@rust-conventions
npx skills add veeso/agents-code-conventions@gleam-conventions
npx skills add veeso/agents-code-conventions@cargo-toml-conventions
npx skills add veeso/agents-code-conventions@js-conventions
npx skills add veeso/agents-code-conventions@ts-conventions
npx skills add veeso/agents-code-conventions@md-conventions
```

### Install globally (all projects)

```bash
npx skills add veeso/agents-code-conventions -g
```

You don't need to install all skills — pick only the ones relevant to your project.

### Verify

Start a coding agent session and verify the skills are loaded. For example, in Claude Code run `/skills` to list installed skills. Ask the agent to write code in a supported language and it will follow the conventions automatically.

## How It Works

Each skill consists of a `SKILL.md` file (which tells the agent when to activate and what to do) and one or more guideline text files containing the actual rules. When the agent detects that you're working with a matching file type, it reads the guidelines and enforces them on all code it writes or modifies.

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
| gleam-conventions | — | [Official Gleam conventions document](https://github.com/gleam-lang/website/blob/main/documentation/conventions-patterns-anti-patterns.djot) |
| js-conventions | `AIRBNB-` | Auto-fetched from [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) |
| ts-conventions | `GOOGLE-` | Auto-fetched from [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) |
| md-conventions | `MD-` | Auto-fetched from [markdownlint](https://github.com/DavidAnson/markdownlint) |

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
