---
name: zizmor-conventions
description: ALWAYS use this skill BEFORE writing or modifying ANY GitHub Actions file (.github/workflows/*.yml, *.yaml, action.yml, action.yaml), even for trivial workflow changes. Enforces zizmor security conventions (ZIZMOR- prefix) for GitHub Actions and REQUIRES running zizmor after every change until all findings are resolved. This skill is MANDATORY for all GitHub Actions editing.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - github-actions
    - ci
    - security
    - conventions
    - zizmor
---

# GitHub Actions Conventions (zizmor)

This skill enforces secure GitHub Actions authoring and validates every change
with [zizmor](https://docs.zizmor.sh), a static analysis tool for GitHub Actions.

## When to Use

- Creating any workflow under `.github/workflows/`
- Modifying an existing workflow (any change, no matter how small)
- Creating or editing a composite/Docker `action.yml` / `action.yaml`
- Reviewing or refactoring CI configuration

## Guidelines

Conventions use the **`ZIZMOR-`** prefix, derived from zizmor's audit set.
These identifiers are for referencing rules in discussion only.
Full audit docs: <https://docs.zizmor.sh/audits/>.

**NEVER write convention identifiers as code comments** (e.g., `# ZIZMOR-TEMPLATE-INJECTION ...`). Apply the conventions silently; do not annotate workflows with the rule that motivated it. (The `# v4.2.2` version comment on a pinned SHA and a justified `# zizmor: ignore[<audit>]` directive are not convention comments and remain allowed.)

### 1. Pin actions by full commit SHA (ZIZMOR-UNPINNED-USES)

Third-party `uses:` MUST be pinned to a full-length commit SHA, with the
human-readable version in a trailing comment. Tags and branches are mutable and
can be repointed at malicious code.

```yaml
# WRONG
- uses: actions/checkout@v4
- uses: some/action@main

# CORRECT
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
```

The trailing `# vX.Y.Z` comment is not decorative — it MUST name the **exact
tag that the pinned SHA points to**, and that tag MUST be the **latest stable
release** of the action. Before writing or accepting a pin, verify both facts
against the upstream repository; never copy a SHA/version pair on trust.

1. Find the latest stable release tag (skip pre-releases/drafts):

   ```bash
   gh release view --repo actions/checkout --json tagName -q .tagName
   # fallback if no GitHub releases:
   git ls-remote --tags https://github.com/actions/checkout.git
   ```

2. Resolve that tag to its full commit SHA and pin to it:

   ```bash
   gh api repos/actions/checkout/git/ref/tags/v4.2.2 -q .object.sha
   # if the tag is annotated and this returns a tag object, dereference it:
   gh api repos/actions/checkout/git/tags/<tag-object-sha> -q .object.sha
   ```

3. Write the resolved SHA with the matching `# vX.Y.Z` comment. The comment and
   the SHA MUST refer to the same tag, and that tag MUST be the latest.

When editing an existing workflow, re-check every already-pinned `uses:`: confirm
the SHA still resolves to the tag named in its comment, and bump both the SHA and
the comment together if a newer stable release exists. A comment that disagrees
with its SHA, or names a stale version, is a defect to fix — not to leave.

### 2. Least-privilege permissions (ZIZMOR-EXCESSIVE-PERMISSIONS)

Set an explicit top-level `permissions:` block. Default to `contents: read` and
grant additional scopes only on the specific job that needs them. Never rely on
the implicit write-all default.

```yaml
# CORRECT
permissions:
  contents: read

jobs:
  release:
    permissions:
      contents: write # only this job needs it
```

### 3. No template injection (ZIZMOR-TEMPLATE-INJECTION)

Never interpolate `${{ ... }}` expressions containing attacker-controllable data
(issue/PR titles, bodies, branch names, etc.) directly into `run:` scripts. Pass
them through `env:` and reference the shell variable, quoted.

```yaml
# WRONG
- run: echo "${{ github.event.issue.title }}"

# CORRECT
- env:
    TITLE: ${{ github.event.issue.title }}
  run: echo "$TITLE"
```

### 4. Avoid dangerous triggers (ZIZMOR-DANGEROUS-TRIGGERS)

Avoid `pull_request_target` and `workflow_run` combined with checkout of
untrusted refs. If unavoidable, do not check out or execute attacker-controlled
code, and keep secrets out of the privileged context.

### 5. Restrict credential persistence (ZIZMOR-ARTIPACKED)

When `actions/checkout` does not need the stored token for later steps, set
`persist-credentials: false` to avoid leaking credentials into artifacts.

```yaml
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
  with:
    persist-credentials: false
```

### 6. No hardcoded credentials (ZIZMOR-HARDCODED-CONTAINER-CREDENTIALS)

Never inline registry/container credentials. Use `secrets`.

### 7. Prefer trusted publishing (ZIZMOR-USE-TRUSTED-PUBLISHING)

For package publishing (PyPI, etc.) use OIDC trusted publishing instead of
long-lived API token secrets.

### 8. Scope secrets narrowly (ZIZMOR-OVERPROVISIONED-SECRETS, ZIZMOR-SECRETS-INHERIT)

Do not pass `secrets: inherit` to reusable workflows. Enumerate only the secrets
actually required. Do not expose all of `secrets` via `toJSON`.

### 9. Guard self-hosted runners (ZIZMOR-SELF-HOSTED-RUNNER)

Do not run untrusted code (e.g. from `pull_request`) on self-hosted runners.

### 10. Verify action authenticity (ZIZMOR-IMPOSTOR-COMMIT, ZIZMOR-KNOWN-VULNERABLE-ACTIONS)

Only use SHAs that actually belong to the referenced repo/tag, and never pin to
action versions with known security advisories.

## Mandatory Verification — run zizmor until green

**After ANY change to a GitHub Actions file, you MUST run zizmor and keep
fixing + re-running until it reports zero findings.** Do not consider the task
complete while findings remain.

Install (pick one):

```bash
uv tool install zizmor      # recommended
pipx install zizmor
brew install zizmor
cargo install zizmor
```

Run against the changed file(s) or the whole workflows directory:

```bash
zizmor .github/workflows/
# or a single file
zizmor .github/workflows/ci.yml
```

Loop until clean:

1. Run `zizmor <path>`.
2. If it reports any finding, fix the workflow per the relevant `ZIZMOR-` rule
   above (or the linked audit doc).
3. Re-run `zizmor <path>`.
4. Repeat 1–3 until zizmor exits `0` with **no findings**.

zizmor exits non-zero when findings exist; treat any non-zero exit as
not-done. Only suppress a finding with an inline
`# zizmor: ignore[<audit>]` comment when there is a documented, justified
reason — never to silence the loop.

**No exceptions**: even trivial workflow edits require a clean zizmor run.
