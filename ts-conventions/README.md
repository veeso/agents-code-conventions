# TypeScript Conventions

![claude](https://img.shields.io/badge/Claude-D97757?style=for-the-badge&logo=claude&logoColor=white)
![typescript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)

A [Claude Code](https://claude.ai/code) skill that enforces the [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) when writing or modifying TypeScript files.

## Convention prefix

Guidelines use the **`GOOGLE-`** prefix followed by the section anchor in UPPER_SNAKE_CASE:

| Prefix | Source | File | Example |
|--------|--------|------|---------|
| `GOOGLE-` | [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) | `ts-conventions/ts-guidelines.txt` | `GOOGLE-IDENTIFIERS`, `GOOGLE-TYPE-ASSERTIONS` |

Section anchors are derived from the heading `id` attributes in the upstream HTML guide and uppercased with hyphens (e.g., `id="interfaces-vs-type-aliases"` becomes `GOOGLE-INTERFACES-VS-TYPE-ALIASES`).

## What it enforces

The skill covers the full Google TypeScript Style Guide:

- **Source file structure** - file encoding, file organization
- **Naming** - identifiers, rules by type (classes, methods, constants, etc.)
- **Type system** - type vs. interface, type assertions, `any` vs. `unknown`, type inference
- **Comments & documentation** - JSDoc, inline comments, parameter descriptions
- **Visibility** - access modifiers, readonly
- **Modules** - ES modules, namespace prohibition, import/export patterns
- **Control flow** - exceptions, iterating containers, switch statements
- **Decorators** - restricted usage
- **Source organization** - exports, imports, module-level code
- **Type assertions** - when allowed, how to use
- **Enums** - const enums, string enums
- **Null & undefined** - nullable/undefined types, optional vs. undefined
- **Toolchain** - compiler flags, linting

## Install

### Global install (all projects)

Clone the repository and copy the `ts-conventions` directory into your global Claude Code skills directory:

```bash
git clone https://github.com/veeso/agents-code-conventions.git
cp -r agents-code-conventions/ts-conventions/ts-conventions ~/.claude/skills/ts-conventions
```

### Per-project install

Clone the repository and copy the `ts-conventions` directory into your project's `.claude/skills/` directory:

```bash
git clone https://github.com/veeso/agents-code-conventions.git
mkdir -p /path/to/your/project/.claude/skills
cp -r agents-code-conventions/ts-conventions/ts-conventions /path/to/your/project/.claude/skills/ts-conventions
```

### Verify installation

After installing, start Claude Code and the skill should be listed when you run `/skills`. You can verify it's working by asking Claude to write a simple TypeScript function.

## Updating guidelines

To fetch the latest Google TypeScript Style Guide from upstream:

```bash
bash scripts/fetch-guidelines.sh
```

This updates `ts-conventions/ts-guidelines.txt` with the latest version from Google's style guide. The script uses `pandoc` for best conversion quality; if unavailable, it falls back to a basic `sed` pipeline.

## License

[CC-BY-3.0](LICENSE) - The Google TypeScript Style Guide is licensed under the [Creative Commons Attribution 3.0 Unported License](https://creativecommons.org/licenses/by/3.0/).
