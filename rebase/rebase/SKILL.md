---
name: rebase
description: ALWAYS use this skill when the user asks to rebase or to resolve rebase conflicts. Triggers on "/rebase", "/rebase <branch>", "rebase", "rebase on main", "rebase onto <branch>", "resolve conflicts", "resolve the rebase conflicts", "fix the conflicts". Starts a rebase onto the default branch (or the given branch) when none is in progress, otherwise continues the active one, resolves every conflict so the features of both sides are kept, asks the user only when a conflict is truly impossible to decide, verifies the result, and force pushes with lease.
license: MIT
metadata:
  author: veeso
  version: "1.0.0"
  tags:
    - git
    - rebase
    - conflicts
    - merge
---

# Rebase

This skill rebases the current branch and resolves every conflict on the way.
A conflict means both sides changed the same code for a reason. The goal is a
result that keeps **both** reasons: the feature on the branch and the change
on the base. Picking one side and dropping the other is a last resort, never a
default.

**Violating the letter of these rules is violating the spirit of them.**

## When to Use

- The user runs `/rebase` or `/rebase <branch>`
- The user asks to rebase the current branch, or to rebase onto a branch
- The user asks to resolve conflicts while a rebase is in progress
- A `git rebase` you started stopped on a conflict

## Arguments

- `/rebase`: rebase onto the default branch of `origin`.
- `/rebase <branch>`: rebase onto `<branch>`. A bare name such as `develop`
  means `origin/develop`. A name with a remote such as `upstream/main` uses
  that remote.

The argument is ignored when a rebase is already in progress: the active
rebase is continued. If the user passed a branch that differs from the active
rebase's base, say so and ask whether to continue or abort the active one.

## Ours and Theirs During a Rebase

During a rebase the sides are swapped compared to a merge:

| Label in git            | Meaning during a rebase                            |
| ----------------------- | -------------------------------------------------- |
| `HEAD`, `--ours`        | The base branch, plus the commits already replayed |
| `--theirs`, commit name | The branch commit being replayed right now         |

Never run `git checkout --ours` or `--theirs` on a file without remembering
this table. Getting it wrong silently drops the branch's work.

## Step 1: Start or Resume

1. Detect an active rebase:

   ```bash
   git_dir="$(git rev-parse --git-dir)"
   test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply" && echo active
   ```

   If a rebase is active, skip to [Step 2](#step-2-resolve-the-current-stop).
   A stopped `git merge` or `git cherry-pick` is not a rebase: stop and ask
   the user what to do with it.

2. Require a clean working tree (`git status --porcelain` is empty). If it is
   not, stop and ask the user to commit or stash. Never stash on their behalf,
   since a forgotten stash is lost work.

3. Refuse to rebase the default branch itself or any protected branch. Ask
   the user instead.

4. Resolve the base branch. Without an argument, find the default branch:

   ```bash
   git remote set-head origin --auto >/dev/null 2>&1
   git symbolic-ref --short refs/remotes/origin/HEAD   # e.g. origin/main
   ```

   Fall back to `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`
   if the symbolic ref is missing.

5. Fetch the base:

   ```bash
   git fetch <remote> <base-branch>
   ```

6. Write down the **intent** before rebasing, since it guides every
   resolution:

   - what the branch does: `git log --oneline <remote>/<base>..HEAD` and the
     PR description if a PR exists (`gh pr view --json title,body`);
   - what changed on the base since the branch forked:
     `git log --oneline HEAD..<remote>/<base>`.

7. Save a backup ref so the user can always go back:

   ```bash
   git branch "backup/$(git branch --show-current)-$(date +%Y%m%d%H%M%S)"
   ```

8. Rebase:

   ```bash
   git rebase <remote>/<base-branch>
   ```

   If the branch contains merge commits, ask the user whether to keep them
   (`--rebase-merges`) or flatten them before starting.

   If the rebase finishes without conflicts, go to
   [Step 4](#step-4-verify).

## Step 2: Resolve the Current Stop

Repeat for every stop of the rebase.

1. Identify the commit being replayed and its purpose:

   ```bash
   git log -1 --format='%H %s%n%n%b' REBASE_HEAD
   git show --stat REBASE_HEAD
   ```

2. List the conflicted paths and their kind:

   ```bash
   git status --porcelain | grep -E '^(UU|AA|DU|UD|AU|UA|DD) '
   ```

3. Rewrite the markers of each conflicted file in diff3 style, so the common
   ancestor is visible between `|||||||` and `=======`. This changes no
   configuration (use `diff3` on git older than 2.35):

   ```bash
   git checkout --conflict=zdiff3 -- <file>
   ```

   Skip this for files with no content markers (delete or add conflicts).

4. For each conflicted file, understand **why** each side changed it before
   editing anything:

   - the replayed commit's change: `git show REBASE_HEAD -- <file>`;
   - the base's change since the fork:
     `git log -p "$(git merge-base REBASE_HEAD <remote>/<base>)"..<remote>/<base> -- <file>`;
   - the common ancestor in the diff3 markers.

5. Resolve following the [Resolution Rules](#resolution-rules).

6. Check that nothing is left behind and stage the result:

   ```bash
   git diff --check                         # no leftover markers or whitespace errors
   git grep -nE '^(<<<<<<<|>>>>>>>|\|\|\|\|\|\|\|)( |$)' -- <files>
   git add <files>
   ```

7. Build or type-check the project if it is quick (for example `cargo check`,
   `tsc --noEmit`, `gleam check`). A resolution that does not compile is not a
   resolution. Fix it now, while the context of this commit is fresh.

8. Continue without opening an editor:

   ```bash
   GIT_EDITOR=true git rebase --continue
   ```

   If nothing is left to commit (`git diff --cached --quiet` succeeds), the
   base may already contain this commit's change. Confirm it by reading
   `git show REBASE_HEAD` against the base before running `git rebase --skip`.
   Never skip a commit that still carries work.

9. If the rebase stops again, go back to step 1 of this section. Keep going
   until git reports the rebase is complete.

## Resolution Rules

Apply these in order. Stop at the first rule that decides the conflict.

1. **Combine both changes.** Most conflicts are two independent edits that
   happen to touch nearby lines: a new field on one side and a rename on the
   other, two new imports, two new match arms, two new test cases. Keep both,
   adapting the branch's code to the base's new names, signatures, and
   structure.
2. **The base moved code, the branch edited it.** Apply the branch's edit at
   the code's new location, in its new shape. Never resurrect the old
   location.
3. **The base deleted code, the branch edited it.** Find out why it was
   deleted (commit message, PR). If it was replaced, port the branch's edit to
   the replacement. If it was removed on purpose and the branch's edit only
   maintained it, drop the edit.
4. **The branch deleted code, the base edited it.** Keep the deletion only if
   the branch replaced the code, and port the base's edit to the replacement.
5. **Generated files and lockfiles** (`Cargo.lock`, `package-lock.json`,
   `pnpm-lock.yaml`, `yarn.lock`, `go.sum`, `poetry.lock`, generated code):
   never hand-merge. Take the base version, keep the manifest change from
   both sides, and regenerate with the project's tool (for example
   `cargo update -w`, `npm install`, `pnpm install`).
6. **Version numbers and changelogs:** keep the base's released entries and
   add the branch's entry on top. Never lower a version the base raised.
7. **Formatting-only conflicts:** take the base's formatting and re-apply the
   branch's change, then run the project's formatter.

### When to Ask the User

Ask only when the two sides are **mutually exclusive** and the code, the
commit messages, and the PR do not say which one wins. For example:

- both sides set the same constant, default, or config value to different
  values;
- both sides implement the same behavior in incompatible ways;
- the base removed a feature on purpose and the branch extends it.

When you ask, show the conflict with the base version, the branch version,
the reason each side changed, and your recommended resolution, so the user can
answer in one word. Resolve every other conflict first, and batch the
questions for one stop together.

Never ask about a conflict the rules above decide. Never guess on one they do
not.

## Step 3: Abort Safely

If the rebase cannot be completed (the user asks to stop, or a resolution is
going badly wrong), run `git rebase --abort`. The branch returns to its
original state. The backup ref from Step 1 stays as a second safety net.

## Step 4: Verify

1. Confirm the rebase is complete and the history is right:

   ```bash
   git status
   git log --oneline <remote>/<base>..HEAD
   ```

   The branch's commits must sit on top of `<remote>/<base>`, with none lost
   except those skipped as empty in Step 2.

2. Compare the branch's net change before and after the rebase. Only the
   conflict resolutions and the adaptations to the base should differ:

   ```bash
   git range-diff <remote>/<base> <backup-ref> HEAD
   ```

   Investigate any difference you cannot explain.

3. Run the project's formatter, linter, build, and test suite. If something
   fails because of the rebase, fix it in the commit that introduced the
   breakage (`git commit --fixup <sha>` then
   `git rebase -i --autosquash <remote>/<base>` with `GIT_SEQUENCE_EDITOR=true`).
   If a failure also happens on `<remote>/<base>`, report it and do not fix
   it.

4. Never push a branch that does not build or whose tests fail because of the
   rebase. Report the failure and stop.

## Step 5: Force Push

Push with lease, never with a bare `--force`:

```bash
git push --force-with-lease --force-if-includes
```

If the branch has no upstream, use `git push --force-with-lease -u origin HEAD`.

If the lease is rejected, someone else pushed to the branch. Never retry with
`--force`. Fetch, show the user the new remote commits, and ask how to
proceed.

Never force push the default branch or any protected branch.

## Step 6: Report

Tell the user, briefly:

- the base the branch was rebased onto and how many commits were replayed;
- each conflict and how it was resolved, one line each;
- any commit skipped as empty, and why;
- the verification commands run and their result;
- the backup ref name, which they can delete once satisfied with
  `git branch -D <backup-ref>`.
