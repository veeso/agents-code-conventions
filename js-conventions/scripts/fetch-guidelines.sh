#!/usr/bin/env bash
set -euo pipefail

# Fetches the latest Airbnb JavaScript Style Guide from the upstream repository
# and saves it as js-conventions/js-guidelines.txt.
#
# The guide is a single README.md with numbered rules and semantic anchors.

REPO_URL="https://raw.githubusercontent.com/airbnb/javascript/master/README.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_FILE="$PROJECT_ROOT/js-conventions/js-guidelines.txt"

echo "Fetching Airbnb JavaScript Style Guide..."

# Download the raw README
curl -fsSL "$REPO_URL" -o "$OUTPUT_FILE.tmp"

# Write header and append content
cat > "$OUTPUT_FILE" <<'HEADER'
<!-- Airbnb JavaScript Style Guide. Licensed under the MIT license. -->
<!-- Source: https://github.com/airbnb/javascript -->

# Airbnb JavaScript Style Guide

This file contains the full Airbnb JavaScript Style Guide for reference.
Rules use the AIRBNB- prefix followed by their section number (e.g., AIRBNB-2.1).

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
