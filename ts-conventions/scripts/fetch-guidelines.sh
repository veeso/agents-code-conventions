#!/usr/bin/env bash
set -euo pipefail

# Fetches the latest Google TypeScript Style Guide and converts it from HTML
# to a readable plain-text format saved as ts-conventions/ts-guidelines.txt.
#
# Requires: curl, sed, and optionally pandoc for best results.

SOURCE_URL="https://google.github.io/styleguide/tsguide.html"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_FILE="$PROJECT_ROOT/ts-conventions/ts-guidelines.txt"

echo "Fetching Google TypeScript Style Guide..."

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

curl -fsSL "$SOURCE_URL" -o "$TMPDIR/tsguide.html"

# Write header
cat > "$OUTPUT_FILE" <<'HEADER'
<!-- Google TypeScript Style Guide. Licensed under CC-BY-3.0. -->
<!-- Source: https://google.github.io/styleguide/tsguide.html -->

# Google TypeScript Style Guide

This file contains the full Google TypeScript Style Guide for reference.
Rules use the GOOGLE- prefix followed by their section anchor in UPPER_SNAKE_CASE
(e.g., GOOGLE-IDENTIFIERS, GOOGLE-TYPE-ASSERTIONS).

---

HEADER

# Convert HTML to text — prefer pandoc for quality, fall back to sed pipeline
if command -v pandoc &>/dev/null; then
    echo "Using pandoc for HTML-to-Markdown conversion..."
    pandoc -f html -t markdown_strict --wrap=auto "$TMPDIR/tsguide.html" >> "$OUTPUT_FILE"
else
    echo "pandoc not found, using basic sed conversion..."
    # Extract the body content and do basic HTML-to-text conversion
    sed -n '/<body/,/<\/body>/p' "$TMPDIR/tsguide.html" \
        | sed 's/<h1[^>]*>/\n# /g; s/<\/h1>//g' \
        | sed 's/<h2[^>]*>/\n## /g; s/<\/h2>//g' \
        | sed 's/<h3[^>]*>/\n### /g; s/<\/h3>//g' \
        | sed 's/<h4[^>]*>/\n#### /g; s/<\/h4>//g' \
        | sed 's/<code[^>]*class="language-ts bad"[^>]*>/\n```ts\n\/\/ BAD\n/g' \
        | sed 's/<code[^>]*class="language-ts good"[^>]*>/\n```ts\n\/\/ GOOD\n/g' \
        | sed 's/<code[^>]*>/\n```\n/g; s/<\/code>/\n```\n/g' \
        | sed 's/<pre[^>]*>//g; s/<\/pre>//g' \
        | sed 's/<li[^>]*>/- /g; s/<\/li>//g' \
        | sed 's/<p[^>]*>/\n/g; s/<\/p>/\n/g' \
        | sed 's/<br[^>]*>/\n/g' \
        | sed 's/<strong>/\*\*/g; s/<\/strong>/\*\*/g' \
        | sed 's/<em>/\*/g; s/<\/em>/\*/g' \
        | sed 's/<a [^>]*href="\([^"]*\)"[^>]*>/[\1](/g; s/<\/a>/)/g' \
        | sed 's/<[^>]*>//g' \
        | sed '/^$/N;/^\n$/d' \
        >> "$OUTPUT_FILE"
fi

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
