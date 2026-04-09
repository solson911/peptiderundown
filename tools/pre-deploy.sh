#!/bin/bash
# pre-deploy.sh
# Hard gate that must pass before an article is committed/pushed.
# Validates: (1) hero image exists for the slug, (2) Astro build succeeds.
# Exits non-zero on any failure. Run from anywhere.
#
# Usage:
#   pre-deploy.sh <slug>          # check one article + full build
#   pre-deploy.sh                 # check all articles + full build

set -uo pipefail

# Resolve paths relative to this script so the gate works from any clone.
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE="$(cd "$TOOLS_DIR/.." && pwd)"
GUARD="$TOOLS_DIR/check-article-images.sh"

slug="${1:-}"

echo "==> [pre-deploy] image guard"
if [ -n "$slug" ]; then
  bash "$GUARD" "$slug" || { echo "FAIL: image guard"; exit 1; }
else
  bash "$GUARD" || { echo "FAIL: image guard"; exit 1; }
fi

echo ""
echo "==> [pre-deploy] astro build"
cd "$SITE" || { echo "FAIL: cannot cd to $SITE"; exit 1; }
if ! npm run build --silent > /tmp/pre-deploy-build.log 2>&1; then
  echo "FAIL: astro build errored. Last 40 lines:"
  tail -40 /tmp/pre-deploy-build.log
  echo ""
  echo "Full log: /tmp/pre-deploy-build.log"
  exit 1
fi

echo ""
echo "OK: pre-deploy checks passed (image present, astro build clean)"
exit 0
