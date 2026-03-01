---
name: rust-conventions
description: ALWAYS use this skill BEFORE writing or modifying ANY Rust code (.rs files), even for simple Hello World programs. Enforces Microsoft Rust coding guidelines (M- prefix) and custom extensions (X- prefix), applies M-CANONICAL-DOCS documentation, adds compliance comments, and validates against guidelines. This skill is MANDATORY for all Rust development.
---

# Rust Development

This skill automatically enforces Rust coding standards and best practices when creating or modifying Rust code.

## Guidelines

There are two sets of conventions:

- **`M-` prefix** (Microsoft): Upstream guidelines from [microsoft/rust-guidelines](https://github.com/microsoft/rust-guidelines). Defined in [rust-guidelines.txt](./rust-guidelines.txt).
- **`X-` prefix** (Extension): Custom conventions added by the repository maintainer. Defined in [custom-guidelines.txt](./custom-guidelines.txt).

Both sets of guidelines MUST be followed.

## Instructions

**CRITICAL**: This skill MUST be invoked for ANY Rust code operation, including:
- Creating new .rs files (even simple examples like Hello World)
- Modifying existing .rs files (any change, no matter how small)
- Reviewing Rust code
- Refactoring Rust code

**Process**:
1. Read [rust-guidelines.txt](./rust-guidelines.txt) to understand all `M-` compliance requirements
2. Read [custom-guidelines.txt](./custom-guidelines.txt) to understand all `X-` compliance requirements
3. Before writing/modifying ANY Rust code, ensure edits conform to both guideline sets
4. Apply proper M-CANONICAL-DOCS documentation format
5. Add compliance comments
6. Comments must ALWAYS be written in American English, unless the user explicitly requests a different comment language
7. If the file is fully compliant, add a comment: `// Rust guideline compliant {date}` where {date} is the guideline date/version

**No exceptions**: Even for trivial code like "Hello World", guidelines must be followed.
