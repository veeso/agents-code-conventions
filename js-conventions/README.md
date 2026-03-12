# JavaScript Conventions

![claude](https://img.shields.io/badge/Claude-D97757?style=for-the-badge&logo=claude&logoColor=white)
![javascript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)

A [Claude Code](https://claude.ai/code) skill that enforces the [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) when writing or modifying JavaScript files.

## Convention prefix

Guidelines use the **`AIRBNB-`** prefix followed by the rule's section number from the upstream guide:

| Prefix | Source | File | Example |
|--------|--------|------|---------|
| `AIRBNB-` | [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) | `js-conventions/js-guidelines.txt` | `AIRBNB-2.1`, `AIRBNB-15.1` |

Rules are numbered by section (e.g., 2.1 = References, rule 1 = "prefer const"). Reference them as `AIRBNB-2.1` in code comments.

## What it enforces

The skill covers the full Airbnb JavaScript Style Guide:

- **Types** - primitives vs. complex types
- **References** - `const`/`let` over `var`
- **Objects** - shorthand, computed properties, spread
- **Arrays** - literals, spreads, `Array.from`
- **Destructuring** - object and array destructuring
- **Strings** - template literals, no `eval`
- **Functions** - declarations, default parameters, rest/spread
- **Arrow Functions** - usage, implicit return, parentheses
- **Classes & Constructors** - `class` syntax, inheritance
- **Modules** - `import`/`export`, named exports
- **Iterators & Generators** - higher-order functions over loops
- **Properties** - dot notation, bracket notation
- **Variables** - grouping, no chaining, no unused
- **Hoisting** - `var`/`function`/`class` hoisting behavior
- **Comparison Operators** - `===`/`!==`, ternaries, no nesting
- **Blocks** - braces, `if`/`else` style
- **Control Statements** - line length, selection operators
- **Comments** - `//` and `/** */` usage, TODOs, FIXMEs
- **Whitespace** - indentation, spacing, newlines
- **Commas** - trailing commas
- **Semicolons** - required
- **Type Casting & Coercion** - explicit coercion
- **Naming Conventions** - camelCase, PascalCase, UPPER_SNAKE_CASE

## ESLint & Prettier Configs

The skill includes ready-to-use configuration files aligned with the Airbnb style guide:

| File | Description | Install command |
|------|-------------|-----------------|
| `.prettierrc.json` | Prettier config (2-space indent, single quotes, trailing commas, 100-char width) | `npm install --save-dev prettier` |
| `eslint.config.js` | ESLint 9 flat config | `npm install --save-dev eslint eslint-config-airbnb-extended` |

> **Note**: The official `eslint-config-airbnb` package does not support ESLint 9 flat config. The config uses [`eslint-config-airbnb-extended`](https://github.com/NishargShah/eslint-config-airbnb-extended), the actively maintained community replacement.

When you ask Claude to set up ESLint or Prettier for your JavaScript project, it will provide these configs automatically.

## Install

### Global install (all projects)

Clone the repository and copy the `js-conventions` directory into your global Claude Code skills directory:

```bash
git clone https://github.com/veeso/agents-code-conventions.git
cp -r agents-code-conventions/js-conventions/js-conventions ~/.claude/skills/js-conventions
```

### Per-project install

Clone the repository and copy the `js-conventions` directory into your project's `.claude/skills/` directory:

```bash
git clone https://github.com/veeso/agents-code-conventions.git
mkdir -p /path/to/your/project/.claude/skills
cp -r agents-code-conventions/js-conventions/js-conventions /path/to/your/project/.claude/skills/js-conventions
```

### Verify installation

After installing, start Claude Code and the skill should be listed when you run `/skills`. You can verify it's working by asking Claude to write a simple JavaScript function.

## Updating guidelines

To fetch the latest Airbnb JavaScript Style Guide from upstream:

```bash
bash scripts/fetch-guidelines.sh
```

This updates `js-conventions/js-guidelines.txt` with the latest version from the Airbnb repository.

## License

[MIT](LICENSE) - The Airbnb JavaScript Style Guide is licensed under the [MIT license](https://github.com/airbnb/javascript/blob/master/LICENSE.md).
