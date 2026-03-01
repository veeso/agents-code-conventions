# Gleam Conventions

![claude](https://img.shields.io/badge/Claude-D97757?style=for-the-badge&logo=claude&logoColor=white)
![gleam](https://img.shields.io/badge/Gleam-ffaff3?style=for-the-badge&logo=gleam&logoColor=white)

> [!WARNING]
> Official Gleam conventions are still being defined and are not yet finalized.
> As a result, this skill may still contain guidelines that turn out to be anti-patterns
> or that conflict with the official conventions once they are published.
> Use your own judgement and check the [official Gleam documentation](https://gleam.run/) for the latest guidance.

A [Claude Code](https://claude.ai/code) skill that enforces idiomatic Gleam coding conventions when writing or modifying `.gleam` files. The skill is based on patterns observed across major Gleam projects (stdlib, gleam_otp, gleam_erlang, Lustre, mug, gftp) and the official Gleam documentation.

## What it does

When activated, the skill instructs Claude Code to follow the **Pragmatic Gleam Guidelines** (`gleam-guidelines.txt`) before writing or modifying any Gleam code. The guidelines cover:

- **Official Gleam conventions** - qualified imports, function annotations, Result for fallibility, singular modules, acronyms, conversion naming, core libraries, source directories
- **Naming conventions** - `snake_case` for functions/variables, `PascalCase` for types/constructors, stdlib naming patterns
- **Module organization** - package structure, `internal/` for private APIs, focused modules
- **Documentation** - module docs (`////`), item docs (`///`), canonical sections, variant docs, liberal comments
- **Error handling** - `Result` types, specific error types, `use` chaining, no panicking in libraries
- **Type design** - opaque types, custom types, labelled arguments, make invalid states impossible
- **Import conventions** - qualified imports only for functions/constants, type-only imports
- **Pattern matching** - exhaustive matching, pattern-over-conditionals
- **Pipe operator** - subject-first parameter design for clean pipe chains
- **Testing** - mirror source structure, descriptive test names, `_test` suffix
- **Examples** - `dev/` directory with `example_*` naming convention
- **OTP actors** - actor model, opaque messages, state guards, request-reply, no process-as-state
- **Project config** - `gleam.toml`, `gleam format`, conventional commits, tool config
- **Library design** - wrap externals, callback resources
- **FFI** - isolate in `_ffi.erl` / `_ffi.mjs` files, no Dynamic for FFI types
- **Anti-patterns** - utils modules, check-then-assert, type aliases, fragmented modules, namespace trespassing, category theory overuse, processes as state stores

## Install

### Global install (all projects)

Clone the repository and copy the `gleam-conventions` directory into your global Claude Code skills directory:

```bash
git clone https://github.com/veeso/gleam-conventions.git
cp -r gleam-conventions/gleam-conventions ~/.claude/skills/gleam-conventions
```

This makes the skill available in every project you work on with Claude Code.

### Per-project install

Clone the repository and copy the `gleam-conventions` directory into your project's `.claude/skills/` directory:

```bash
git clone https://github.com/veeso/gleam-conventions.git
mkdir -p /path/to/your/project/.claude/skills
cp -r gleam-conventions/gleam-conventions /path/to/your/project/.claude/skills/gleam-conventions
```

This makes the skill available only within that specific project.

### Verify installation

After installing, start Claude Code and the skill should be listed when you run `/skills`. You can verify it's working by asking Claude to write a simple Gleam function - it should follow the guidelines automatically.

## Guidelines reference

The full guidelines are in [`gleam-conventions/gleam-guidelines.txt`](./gleam-conventions/gleam-guidelines.txt). Each guideline has a unique ID (e.g., `G-CANONICAL-DOCS`) for easy reference. Here's the complete list:

### Official Gleam Conventions (Maximum Priority)

| ID | Guideline |
| --- | --- |
| G-QUALIFIED-ONLY | Avoid unqualified importing of functions and constants |
| G-ANNOTATE-FN | Annotate all module functions |
| G-RESULT-ERRORS | Use Result for fallible functions |
| G-SINGULAR-MODULES | Use singular module names |
| G-ACRONYMS | Treat acronyms as single words |
| G-CONVERSION-NAMES | Name conversion functions as prescribed (`x_to_y`) |
| G-TRY-PREFIX | Name short-circuiting result functions with `try_` |
| G-CORE-LIBS | Use the core libraries |
| G-TOOL-CONFIG | Keep tool config in `gleam.toml` |
| G-SOURCE-DIRS | Use the correct source code directory (`src`, `dev`, `test`) |

### Guidelines

| ID | Guideline |
| --- | --- |
| G-DESIGN-FOR-AI | Design with AI use in mind |
| G-SNAKE-CASE-FN | Use snake_case for functions and variables |
| G-PASCAL-CASE-TYPES | Use PascalCase for types and constructors |
| G-CONST-NAMES | Constants use lowercase snake_case |
| G-STDLIB-NAMES | Follow standard library naming patterns |
| G-MODULE-STRUCTURE | Modules mirror the package name |
| G-INTERNAL-MODULES | Internal modules are private implementation |
| G-FOCUSED-MODULES | Keep modules focused |
| G-MODULE-DOCS | Module documentation is mandatory |
| G-CANONICAL-DOCS | Public items have documentation comments |
| G-DOCUMENT-VARIANTS | Document type variants |
| G-COMMENT-LIBERALLY | Comment liberally |
| G-ERROR-TYPES | Define situation-specific error types |
| G-USE-RESULT-CHAIN | Use `use` for Result chaining |
| G-ASSERT-FOR-BUGS | Assertions are for application code only |
| G-OPAQUE-TYPES | Use opaque types for encapsulation |
| G-CUSTOM-TYPES | Use custom types idiomatically |
| G-LABELLED-ARGS | Use labelled arguments for clarity |
| G-EXHAUSTIVE-MATCH | Exhaustive pattern matching |
| G-PATTERN-OVER-IF | Use pattern matching over conditionals |
| G-PIPE-FRIENDLY | Design functions for piping |
| G-TEST-STRUCTURE | Test files mirror source structure |
| G-TEST-NAMES | Test names describe behavior |
| G-DEV-EXAMPLES | Examples live in the `dev/` directory |
| G-ACTOR-MODEL | Use the actor model for concurrent protocols |
| G-ACTOR-MESSAGES-OPAQUE | Actor message types are opaque |
| G-ACTOR-STATE-GUARDS | Actors serialize operations with state guards |
| G-ACTOR-REQUEST-REPLY | Use subjects for request-reply |
| G-GLEAM-TOML | gleam.toml conventions |
| G-FORMAT-CODE | Format code before committing |
| G-CONVENTIONAL-COMMITS | Use conventional commits |
| G-WRAP-EXTERNALS | Wrap external dependencies |
| G-CALLBACK-RESOURCES | Use callbacks for resource-scoped operations |
| G-FFI-ISOLATION | Isolate FFI in dedicated files |
| G-IMMUTABLE-DATA | Prefer immutable data transformations |
| G-OPTION-NOT-NIL | Use Option for optional values |
| G-TODO-PANIC | Use todo and panic appropriately |

### Anti-patterns

| ID | Anti-pattern |
| --- | --- |
| G-NO-UTILS | Do not create utils modules |
| G-NO-FRAGMENTED-MODULES | Do not fragment modules prematurely |
| G-NO-CHECK-THEN-ASSERT | Do not check-then-assert |
| G-NO-TYPE-ALIASES | Do not provide type aliases for common types |
| G-NO-NAMESPACE-TRESPASS | Do not trespass in other package namespaces |
| G-NO-DYNAMIC-FFI | Do not use Dynamic for FFI types |
| G-NO-CATEGORY-THEORY | Do not overuse category theory abstractions |
| G-NO-PROCESS-STATE | Do not use processes as simple state stores |

## License

This project is licensed under the MIT LICENSE. Read the full [LICENSE](./LICENSE).
