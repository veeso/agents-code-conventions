---
name: md-conventions
description: ALWAYS use this skill BEFORE writing or modifying ANY Markdown file (.md files), even for simple READMEs. Enforces markdownlint rules (MD- prefix), validates heading structure, whitespace, list formatting, and more against md-guidelines.txt. This skill is MANDATORY for all Markdown editing.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - markdown
    - conventions
    - linting
    - markdownlint
---

# Markdown Development

This skill automatically enforces Markdown standards and best practices when creating or modifying Markdown files.

## Guidelines

Conventions use the **`MD-`** prefix, derived from [markdownlint](https://github.com/DavidAnson/markdownlint). The full rules are in [md-guidelines.txt](./md-guidelines.txt).

Rules are identified by their rule number from the upstream documentation (e.g., rule `MD001` becomes `MD-001`). When referencing a rule in comments, use the hyphenated form: `<!-- MD-001 -->`.

## Instructions

**CRITICAL**: This skill MUST be invoked for ANY Markdown file operation, including:

- Creating new .md files (even simple READMEs)
- Modifying existing Markdown files (any change, no matter how small)
- Reviewing Markdown files
- Refactoring Markdown document structure

**Process**:

1. Read [md-guidelines.txt](./md-guidelines.txt) to understand all compliance requirements
2. Before writing/modifying ANY Markdown file, ensure edits conform to the guidelines
3. Heading levels must only increment by one level at a time (MD-001)
4. Use consistent heading style — prefer ATX style `#` headings (MD-003)
5. No trailing spaces at end of lines (MD-009)
6. No multiple consecutive blank lines (MD-012)
7. Keep line length reasonable (MD-013)
8. Lists must be surrounded by blank lines (MD-032)
9. Files must end with a single newline character (MD-047)
10. No bare URLs — use angle brackets or proper link syntax (MD-034)
11. Use consistent emphasis style throughout the document (MD-049, MD-050)

**No exceptions**: Even for trivial Markdown files, guidelines must be followed.
