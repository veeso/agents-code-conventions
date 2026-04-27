# JavaScript Conventions

![javascript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)

A coding agent skill that enforces the [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) when writing or modifying JavaScript files.

## Convention prefix

Guidelines use the **`AIRBNB-`** prefix followed by the rule's section number from the upstream guide:

| Prefix    | Source                                                                | File                               | Example                     |
| --------- | --------------------------------------------------------------------- | ---------------------------------- | --------------------------- |
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

| File               | Description                                                                      | Install command                                               |
| ------------------ | -------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `prettierrc.json`  | Prettier config (2-space indent, single quotes, trailing commas, 100-char width) | `npm install --save-dev prettier`                             |
| `eslint.config.js` | ESLint 9 flat config                                                             | `npm install --save-dev eslint eslint-config-airbnb-extended` |

> **Note**: The official `eslint-config-airbnb` package does not support ESLint 9 flat config. The config uses [`eslint-config-airbnb-extended`](https://github.com/NishargShah/eslint-config-airbnb-extended), the actively maintained community replacement.

When you ask the agent to set up ESLint or Prettier for your JavaScript project, it will provide these configs automatically.

## Install

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@js-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@js-conventions -g
```

### Verify installation

After installing, start a coding agent session and verify the skill is loaded. You can verify it's working by asking the agent to write a simple JavaScript function.

## Updating guidelines

To fetch the latest Airbnb JavaScript Style Guide from upstream:

```bash
bash scripts/fetch-guidelines.sh
```

This updates `js-conventions/js-guidelines.txt` with the latest version from the Airbnb repository.

## License

[MIT](LICENSE) - The Airbnb JavaScript Style Guide is licensed under the [MIT license](https://github.com/airbnb/javascript/blob/master/LICENSE.md).
