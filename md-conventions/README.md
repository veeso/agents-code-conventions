# Markdown Conventions

![markdown](https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white)

A coding agent skill that enforces [markdownlint](https://github.com/DavidAnson/markdownlint) rules when writing or modifying Markdown files.

## Convention prefix

Guidelines use the **`MD-`** prefix followed by the rule number:

| Prefix | Source                                                     | File                               | Example                      |
| ------ | ---------------------------------------------------------- | ---------------------------------- | ---------------------------- |
| `MD-`  | [markdownlint](https://github.com/DavidAnson/markdownlint) | `md-conventions/md-guidelines.txt` | `MD-001`, `MD-032`, `MD-047` |

Rule numbers come directly from the upstream markdownlint documentation (e.g., `MD001` is referenced as `MD-001`).

## What it enforces

The skill covers the full markdownlint rule set:

- **Headings** - level increment, style consistency, spacing, duplicate content
- **Whitespace** - trailing spaces, multiple blank lines, indentation
- **Lists** - style consistency, indentation, spacing, marker patterns
- **Line length** - configurable maximum line length
- **Links** - bare URLs, link fragments, image alt text
- **Code blocks** - fenced vs. indented, language specification, style
- **Emphasis** - consistent bold/italic style
- **HTML** - inline HTML restrictions, self-closing tags
- **Structure** - first heading level, single H1, blank lines around elements
- **Content** - reversed link syntax, spaces in links/images

## Install

Install with [`npx skills`](https://github.com/vercel-labs/skills):

```bash
# Install for current project
npx skills add veeso/agents-code-conventions@md-conventions

# Or install globally (all projects)
npx skills add veeso/agents-code-conventions@md-conventions -g
```

### Verify installation

After installing, start a coding agent session and verify the skill is loaded. You can verify it's working by asking the agent to write a simple Markdown document.

## Updating guidelines

To fetch the latest markdownlint rules from upstream:

```bash
bash scripts/fetch-guidelines.sh
```

This updates `md-conventions/md-guidelines.txt` with the latest version from the markdownlint repository.

## License

[MIT](LICENSE) - markdownlint is licensed under the [MIT license](https://github.com/DavidAnson/markdownlint/blob/main/LICENSE).
