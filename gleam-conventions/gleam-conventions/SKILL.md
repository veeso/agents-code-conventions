---
name: gleam-conventions
description: ALWAYS use this skill BEFORE writing or modifying ANY Gleam code (.gleam files), even for simple Hello World programs. Enforces idiomatic Gleam coding guidelines from the official Gleam project conventions, validates naming conventions, module organization, error handling patterns, OTP actor patterns, and more against gleam-guidelines.txt. This skill is MANDATORY for all Gleam development.
---

# Gleam Development

This skill automatically enforces Gleam coding standards and best practices when creating or modifying Gleam code.

## Instructions

**CRITICAL**: This skill MUST be invoked for ANY Gleam code operation, including:

- Creating new .gleam files (even simple examples like Hello World)
- Modifying existing .gleam files (any change, no matter how small)
- Reviewing Gleam code
- Refactoring Gleam code

**Process**:

1. Read the [gleam-guidelines.txt](./gleam-guidelines.txt) to understand all compliance requirements
2. Before writing/modifying ANY Gleam code, ensure edits are conformant to the guidelines
3. **Official Gleam Conventions (Maximum Priority)**: The rules in the "Official Gleam Conventions" section take precedence over everything else
4. Apply proper G-CANONICAL-DOCS documentation format (module docs with `////`, item docs with `///`)
5. Ensure correct naming conventions: `snake_case` for functions/variables, `PascalCase` for types/constructors
6. NEVER import functions or constants unqualified — only types (with `type` keyword) and record constructors may be unqualified
7. Follow G-INTERNAL-MODULES for private API organization (place in `internal/` directory)
8. Follow G-RESULT-ERRORS for error handling (use `Result`, not `Option` for fallible functions)
9. Libraries MUST NEVER use `let assert` or `panic` — return `Result` instead (G-ASSERT-FOR-BUGS)
10. Follow G-ACTOR-MODEL and G-ACTOR-MESSAGES-OPAQUE when writing OTP actor code — actors are NOT state stores
11. Follow G-DEV-EXAMPLES when writing examples (place in `dev/` folder with `example_*` naming)
12. Do NOT create type aliases for common types like `Result` or `Subject` (G-NO-TYPE-ALIASES)
13. Do NOT create `utils`, `helpers`, or `common` modules (G-NO-UTILS)
14. Comments must ALWAYS be written in American English, unless the user explicitly requests a different language.

**No exceptions**: Even for trivial code like "Hello World", guidelines must be followed.

---
