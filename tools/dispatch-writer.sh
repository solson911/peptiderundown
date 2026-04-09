#!/bin/bash
# dispatch-writer.sh — single-shot handoff from orchestrator to Claude Code (Opus 4.6).
#
# Purpose: give the openclaw orchestrator ONE non-chained command to invoke,
# so it never has to build a chained `python && git && ...` pipeline that
# trips the openclaw exec sandbox preflight.
#
# Usage:
#   tools/dispatch-writer.sh path/to/filled-dispatch.txt
#
# What it does:
#   1. Validates the dispatch file exists and has no unfilled {{VARS}}
#   2. Pipes its contents to `acpx claude exec` (one-shot ACP session)
#      which spawns Claude Code (Opus 4.6) as the writer agent
#   3. Returns Claude Code's exit code unchanged
#
# What it does NOT do:
#   - It does NOT run gen-image.py
#   - It does NOT touch git
#   - It does NOT write any article content
#   Those are Claude Code's job, executed end-to-end inside the ACP session.

set -uo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 <filled-dispatch-file>" >&2
  exit 2
fi

DISPATCH_FILE="$1"

if [ ! -f "$DISPATCH_FILE" ]; then
  echo "dispatch-writer: file not found: $DISPATCH_FILE" >&2
  exit 2
fi

# Reject any dispatch that still has unfilled template variables.
if grep -q '{{[A-Z_]\+}}' "$DISPATCH_FILE"; then
  echo "dispatch-writer: dispatch file still contains unfilled {{VARS}}:" >&2
  grep -o '{{[A-Z_]\+}}' "$DISPATCH_FILE" | sort -u >&2
  exit 2
fi

# Hand off to Claude Code via acpx (single command, no chaining).
# `exec` is one-shot: a temporary ACP session that executes the prompt
# end-to-end and exits. Claude Code performs every step in the dispatch
# (read templates, write .astro, gen-image, pre-deploy, commit, push, verify).
exec acpx claude exec --file "$DISPATCH_FILE"
