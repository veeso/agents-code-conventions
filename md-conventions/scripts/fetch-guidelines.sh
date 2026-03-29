#!/usr/bin/env bash
set -euo pipefail

# Fetches the latest markdownlint rules documentation from the upstream repository
# and saves it as md-conventions/md-guidelines.txt.
#
# The rules are documented in a single doc/Rules.md file.

REPO_URL="https://raw.githubusercontent.com/DavidAnson/markdownlint/main/doc/Rules.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_FILE="$PROJECT_ROOT/md-conventions/md-guidelines.txt"

echo "Fetching markdownlint rules documentation..."

# Download the raw Rules.md
curl -fsSL "$REPO_URL" -o "$OUTPUT_FILE.tmp"

# Write header and append content
cat > "$OUTPUT_FILE" <<'HEADER'
<!-- markdownlint rules documentation. Licensed under the MIT license. -->
<!-- Source: https://github.com/DavidAnson/markdownlint -->

# markdownlint Rules

This file contains the full markdownlint rules documentation for reference.
Rules use the MD- prefix followed by their rule number (e.g., MD-001, MD-003).

---

HEADER

cat "$OUTPUT_FILE.tmp" >> "$OUTPUT_FILE"
rm -f "$OUTPUT_FILE.tmp"

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
