#!/usr/bin/env bash
set -euo pipefail

# Fetches the latest Microsoft Rust Guidelines from the upstream repository
# and concatenates them into rust-conventions/rust-guidelines.txt.
#
# Resolves mdBook {{#include}} directives so the output is a single flat file.
# This script does NOT modify custom-guidelines.txt (X- prefix conventions).

REPO_URL="https://github.com/microsoft/rust-guidelines.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_FILE="$PROJECT_ROOT/rust-conventions/rust-guidelines.txt"

# Guideline source files in SUMMARY.md order (excluding checklist which has no
# guideline content, and non-guideline sections like agents/FAQ).
GUIDELINE_FILES=(
    "src/guidelines/README.md"
    "src/guidelines/universal/README.md"
    "src/guidelines/libs/README.md"
    "src/guidelines/libs/interop/README.md"
    "src/guidelines/libs/ux/README.md"
    "src/guidelines/libs/resilience/README.md"
    "src/guidelines/libs/building/README.md"
    "src/guidelines/apps/README.md"
    "src/guidelines/ffi/README.md"
    "src/guidelines/safety/README.md"
    "src/guidelines/performance/README.md"
    "src/guidelines/docs/README.md"
    "src/guidelines/ai/README.md"
)

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Cloning microsoft/rust-guidelines (shallow)..."
git clone --depth 1 --quiet "$REPO_URL" "$TMPDIR/repo"

echo "Concatenating guidelines..."

# resolve_includes FILE
# Reads a markdown file and replaces {{#include FILENAME}} directives
# with the content of the referenced file (relative to the file's directory).
resolve_includes() {
    local file="$1"
    local dir
    dir="$(dirname "$file")"

    while IFS= read -r line; do
        if [[ "$line" =~ \{\{#include[[:space:]]+([^}]+)\}\} ]]; then
            local include_file="${BASH_REMATCH[1]}"
            local include_path="$dir/$include_file"
            if [[ -f "$include_path" ]]; then
                cat "$include_path"
                printf '\n'
            else
                echo "<!-- WARNING: include not found: $include_file -->"
            fi
        else
            printf '%s\n' "$line"
        fi
    done < "$file"
}

# Write header
cat > "$OUTPUT_FILE" <<'HEADER'
<!-- Copyright (c) Microsoft Corporation. Licensed under the MIT license. -->

# Pragmatic Rust Guidelines

This file contains all guidelines concatenated for easy reference.

---

HEADER

# Process each guideline file, resolving includes
for file in "${GUIDELINE_FILES[@]}"; do
    filepath="$TMPDIR/repo/$file"
    if [[ -f "$filepath" ]]; then
        resolve_includes "$filepath" >> "$OUTPUT_FILE"
        printf '\n\n' >> "$OUTPUT_FILE"
    else
        echo "WARNING: $file not found, skipping."
    fi
done

# Remove BOM characters if present
if command -v sed &>/dev/null; then
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' $'s/\xef\xbb\xbf//g' "$OUTPUT_FILE"
    else
        sed -i $'s/\xef\xbb\xbf//g' "$OUTPUT_FILE"
    fi
fi

echo "Done. Updated: $OUTPUT_FILE"
echo "Lines: $(wc -l < "$OUTPUT_FILE")"
