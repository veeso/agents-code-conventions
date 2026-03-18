# Rust Conventions

A coding agent skill that enforces Rust coding guidelines when writing or modifying Rust code. It combines [Microsoft's Pragmatic Rust Guidelines](https://github.com/microsoft/rust-guidelines) with custom extensions.

## Convention prefixes

Guidelines use two prefixes to distinguish their origin:

| Prefix | Source | File | Example |
|--------|--------|------|---------|
| `M-` | [Microsoft Rust Guidelines](https://github.com/microsoft/rust-guidelines) | `rust-conventions/rust-guidelines.txt` | `M-CANONICAL-DOCS`, `M-PUBLIC-DEBUG` |
| `X-` | Custom extensions | `rust-conventions/custom-guidelines.txt` | `X-NO-MOD-RS` |

The `M-` conventions are synced from the upstream Microsoft repository. The `X-` conventions are maintained independently and are never overwritten by the fetch script.

The repo ships with `X-NO-MOD-RS`, which enforces using `module_name.rs` instead of the legacy `module_name/mod.rs` style for module organization.

## Installation

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install the rust-conventions skill
npx skills add veeso/agents-code-conventions@rust-conventions

# Install the fetch helper too (optional)
npx skills add veeso/agents-code-conventions@fetch-rust-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@rust-conventions -g
```

### Verify installation

Start a coding agent session and ask it to write some Rust code. The skill should activate automatically and enforce the guidelines.

## Updating Microsoft guidelines

To fetch the latest `M-` conventions from Microsoft's upstream repository:

```bash
bash scripts/fetch-guidelines.sh
```

Or invoke the `fetch-rust-conventions` skill inside a coding agent session.

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
