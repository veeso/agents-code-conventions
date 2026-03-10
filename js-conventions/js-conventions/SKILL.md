---
name: js-conventions
description: ALWAYS use this skill BEFORE writing or modifying ANY JavaScript code (.js, .mjs, .cjs, .jsx files), even for simple scripts. Enforces Airbnb JavaScript Style Guide conventions (AIRBNB- prefix), validates naming conventions, module organization, ES6+ patterns, and more against js-guidelines.txt. This skill is MANDATORY for all JavaScript development.
---

# JavaScript Development

This skill automatically enforces JavaScript coding standards and best practices when creating or modifying JavaScript code.

## Guidelines

Conventions use the **`AIRBNB-`** prefix, derived from the [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript). The full guidelines are in [js-guidelines.txt](./js-guidelines.txt).

Rules are identified by their section number and semantic anchor from the upstream guide (e.g., rule 2.1 with anchor `references--prefer-const` becomes `AIRBNB-2.1`). When referencing a rule in comments, use the numeric form: `// AIRBNB-2.1`.

## Instructions

**CRITICAL**: This skill MUST be invoked for ANY JavaScript code operation, including:

- Creating new .js, .mjs, .cjs, or .jsx files (even simple examples)
- Modifying existing JavaScript files (any change, no matter how small)
- Reviewing JavaScript code
- Refactoring JavaScript code

**Process**:

1. Read [js-guidelines.txt](./js-guidelines.txt) to understand all compliance requirements
2. Before writing/modifying ANY JavaScript code, ensure edits conform to the guidelines
3. Use `const` by default; use `let` only when reassignment is needed; never use `var` (AIRBNB-2.1, 2.2, 2.3)
4. Prefer object shorthand, destructuring, template literals, and ES6+ patterns throughout
5. Use named `export` over `default export` (AIRBNB-10.6)
6. Follow Airbnb naming conventions: camelCase for variables/functions, PascalCase for classes/constructors, UPPER_SNAKE_CASE for exported constants (AIRBNB-23.1 through 23.8)
7. Prefer arrow functions for anonymous functions and callbacks (AIRBNB-8.1)
8. Use `===` and `!==` over `==` and `!=` (AIRBNB-15.1)
9. Comments must ALWAYS be written in American English, unless the user explicitly requests a different language

**No exceptions**: Even for trivial code, guidelines must be followed.
