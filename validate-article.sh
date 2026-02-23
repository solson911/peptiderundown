#!/bin/bash
set -euo pipefail

# Simple article validator for PeptideRundown markdown articles
# Usage: ./validate-article.sh <slug.md>

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <article-file.md>" >&2
  exit 2
fi

FILE="src/pages/articles/$1"
if [ ! -f "$FILE" ]; then
  echo "Not found: $FILE" >&2
  exit 2
fi

words=$(wc -w < "$FILE" | tr -d ' ')

# Counts
em_dashes=$( (grep -o '—' "$FILE" || true) | wc -l | tr -d ' ')
banned=$(grep -Ein "\b(delve|leverage|robust|utilize|landscape|navigate|comprehensive|crucial)\b" "$FILE" || true)
bold_leadins=$( (grep -o '\*\*[^*]*\*\*:' "$FILE" || true) | wc -l | tr -d ' ')
html_links=$(grep -E "<a href=" -n "$FILE" || true)

echo "File: $1"
echo "Words: $words"
echo "Em dashes (—): $em_dashes"
echo "Bold lead-ins (**x**:): $bold_leadins"

fail=0

if [ "$words" -lt 1200 ]; then
  echo "FAIL: word count < 1200"; fail=1
fi

if [ "$em_dashes" -gt 0 ]; then
  echo "FAIL: contains em dashes (—)"; fail=1
fi

if [ -n "$banned" ]; then
  echo "FAIL: contains banned words:"; echo "$banned"; fail=1
fi

if [ -n "$html_links" ]; then
  echo "WARN: contains raw HTML links (<a href=...). Prefer markdown links."; echo "$html_links"
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS"
else
  exit 1
fi
