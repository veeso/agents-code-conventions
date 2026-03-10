---
name: ts-conventions
description: ALWAYS use this skill BEFORE writing or modifying ANY TypeScript code (.ts, .tsx files), even for simple scripts. Enforces Google TypeScript Style Guide conventions (GOOGLE- prefix), validates naming, type system usage, module organization, and more against ts-guidelines.txt. This skill is MANDATORY for all TypeScript development.
---

# TypeScript Development

This skill automatically enforces TypeScript coding standards and best practices when creating or modifying TypeScript code.

## Guidelines

Conventions use the **`GOOGLE-`** prefix, derived from the [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html). The full guidelines are in [ts-guidelines.txt](./ts-guidelines.txt).

Rules are identified by their section anchor from the upstream guide (e.g., section with anchor `identifiers` becomes `GOOGLE-IDENTIFIERS`). When referencing a rule in comments, use the uppercased anchor form: `// GOOGLE-IDENTIFIERS`.

## Instructions

**CRITICAL**: This skill MUST be invoked for ANY TypeScript code operation, including:

- Creating new .ts or .tsx files (even simple examples)
- Modifying existing TypeScript files (any change, no matter how small)
- Reviewing TypeScript code
- Refactoring TypeScript code

**Process**:

1. Read [ts-guidelines.txt](./ts-guidelines.txt) to understand all compliance requirements
2. Before writing/modifying ANY TypeScript code, ensure edits conform to the guidelines
3. Use `const` and `let`; never use `var` (GOOGLE-VARIABLES)
4. Use TypeScript's type system fully: prefer interfaces for object shapes, use type aliases for unions/intersections (GOOGLE-INTERFACES-VS-TYPE-ALIASES)
5. Follow Google naming conventions: camelCase for variables/functions/methods, PascalCase for classes/interfaces/types/enums, CONSTANT_CASE for global constants (GOOGLE-IDENTIFIERS)
6. Do NOT use `any`; prefer `unknown` when the type is truly unknown (GOOGLE-ANY)
7. Use readonly where possible; avoid mutation (GOOGLE-TYPE-ASSERTIONS)
8. Do NOT use TypeScript namespaces (`namespace`/`module`); use ES modules (GOOGLE-NAMESPACES-VS-MODULES)
9. Do NOT use decorators except in frameworks that require them (GOOGLE-DECORATORS)
10. Do NOT use `@ts-ignore`; use `@ts-expect-error` with explanation if suppression is needed
11. Prefer optional chaining (`?.`) and nullish coalescing (`??`) over explicit null checks
12. Comments must ALWAYS be written in American English, unless the user explicitly requests a different language

**No exceptions**: Even for trivial code, guidelines must be followed.
