#!/usr/bin/env bash
# Record that a review passed for the change set exactly as it stands now.
#   .claude/hooks/mark-reviewed.sh code   # after code-reviewer returns APPROVE / APPROVE WITH NITS
#   .claude/hooks/mark-reviewed.sh rls    # after rls-auditor finds no critical issues
# Only run this after the reviewer's verdict actually passed. Any later edit invalidates it.
set -euo pipefail
kind="${1:-}"
case "$kind" in code|rls) ;; *) echo "usage: $0 code|rls" >&2; exit 64;; esac
. "$(dirname "$0")/review-lib.sh"
dir="$(rr_marker_dir)"; mkdir -p "$dir"
fp="$(rr_fingerprint)"
date -u +%Y-%m-%dT%H:%M:%SZ > "$dir/$kind-$fp"
echo "Recorded $kind review for change set $fp"
