---
name: fetch-rust-conventions
description: Fetches the latest Microsoft Rust coding guidelines from the upstream repository and updates rust-guidelines.txt. Does NOT modify custom-guidelines.txt (X- prefix conventions). Use when you need to sync with the latest upstream guidelines.
---

# Fetch Rust Conventions

This skill updates the Microsoft Rust guidelines (`M-` prefix) from the upstream repository.

## Instructions

**IMPORTANT**: This skill ONLY updates `rust-conventions/rust-guidelines.txt` (Microsoft `M-` prefix guidelines).
It does NOT touch `rust-conventions/custom-guidelines.txt` (custom `X-` prefix conventions).

**Process**:
1. Run the fetch script: `bash scripts/fetch-guidelines.sh`
2. Verify the script completed successfully
3. Report the number of lines in the updated file
4. Remind the user to review the changes before committing

**Note**: The script requires `git` to be available and internet access to clone the Microsoft repository.
