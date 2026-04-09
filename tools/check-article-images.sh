#!/bin/bash
# check-article-images.sh
# Verifies that every article's frontmatter `image:` field points to a file
# that actually exists under site/public/. Exits non-zero on any miss.
#
# Usage:
#   check-article-images.sh                # check ALL articles
#   check-article-images.sh <slug> [...]   # check only the given slugs

set -uo pipefail

# Resolve paths relative to this script so the guard works from any clone.
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE="$(cd "$TOOLS_DIR/.." && pwd)"
ARTICLES="$SITE/src/pages/articles"
PUBLIC="$SITE/public"

if [ $# -gt 0 ]; then
  files=()
  for slug in "$@"; do
    if   [ -f "$ARTICLES/$slug.md"    ]; then files+=("$ARTICLES/$slug.md")
    elif [ -f "$ARTICLES/$slug.astro" ]; then files+=("$ARTICLES/$slug.astro")
    else
      echo "ERROR: no article found for slug '$slug'" >&2
      exit 2
    fi
  done
else
  shopt -s nullglob
  files=()
  for f in "$ARTICLES"/*.md "$ARTICLES"/*.astro; do
    base=$(basename "$f")
    # Skip the article index page (not an article itself)
    [ "$base" = "index.astro" ] && continue
    files+=("$f")
  done
fi

missing=0
for f in "${files[@]}"; do
  # Match `image: /foo.webp` (md) and `image: "/foo.webp"` (astro)
  img=$(grep -m1 -E '^\s*image:' "$f" 2>/dev/null \
        | sed -E 's/^\s*image:\s*//; s/^["'"'"']//; s/["'"'"'],?\s*$//' \
        | tr -d '\r')
  if [ -z "$img" ]; then
    echo "MISSING-FIELD: $(basename "$f") has no image: frontmatter"
    missing=$((missing + 1))
    continue
  fi
  if [ ! -f "$PUBLIC$img" ]; then
    echo "MISSING-FILE:  $(basename "$f") -> $img (expected at $PUBLIC$img)"
    missing=$((missing + 1))
  fi
done

if [ "$missing" -gt 0 ]; then
  echo ""
  echo "FAIL: $missing article(s) have missing or broken hero images"
  exit 1
fi

echo "OK: all checked articles have a hero image on disk"
