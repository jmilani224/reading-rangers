#!/usr/bin/env bash
# Stop hook: the code review gate for Reading Rangers.
#
# When the branch has changes, before Claude may end its turn:
#   1. typecheck, lint and test run (whichever npm scripts exist) and must pass
#   2. DB changes (supabase/, *.sql) need an rls-auditor pass for this exact change set
#   3. Code changes need a code-reviewer pass for this exact change set
# A pass is recorded with .claude/hooks/mark-reviewed.sh, keyed to a fingerprint of the diff
# content, so any edit after the review re-arms the gate.
#
# Exit 2 blocks the stop and shows stderr to Claude.
# Bypass (say so out loud when you use one):
#   SKIP_STOP_GATE=1         disable entirely
#   SKIP_CHECKS=1            skip typecheck/lint/test
#   SKIP_CODE_REVIEW_GATE=1  don't block on code review
#   SKIP_RLS_AUDIT_GATE=1    don't block on the RLS audit
set -uo pipefail

[ "${SKIP_STOP_GATE:-0}" = "1" ] && exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
cd "$(git rev-parse --show-toplevel)"
. .claude/hooks/review-lib.sh

CHANGED="$(rr_changed_files)"
[ -z "$CHANGED" ] && exit 0

has_script() {
  [ -f package.json ] && node -e "const p=require('./package.json');process.exit(p.scripts&&p.scripts['$1']?0:1)" >/dev/null 2>&1
}

if [ "${SKIP_CHECKS:-0}" != "1" ] && [ -f package.json ]; then
  for s in typecheck lint test; do
    if has_script "$s"; then
      echo "stop-gate: npm run $s" >&2
      if ! npm -s run "$s" >&2; then
        echo "" >&2
        echo "STOP GATE: 'npm run $s' failed. Fix it, then continue. (Bypass: SKIP_CHECKS=1)" >&2
        exit 2
      fi
    fi
  done

  LARGE="$(echo "$CHANGED" | while read -r f; do
    [ -f "$f" ] || continue
    n=$(wc -l < "$f")
    if [ "$n" -gt 500 ]; then echo "  $f ($n lines)"; fi
  done || true)"
  if [ -n "$LARGE" ]; then
    echo "stop-gate warning: files over 500 lines, note why in the PR if they stay that way:" >&2
    echo "$LARGE" >&2
  fi
fi

FP="$(rr_fingerprint)"
DIR="$(rr_marker_dir)"
BLOCK=0

if [ -n "$(rr_db_files)" ] && [ "${SKIP_RLS_AUDIT_GATE:-0}" != "1" ] && [ ! -f "$DIR/rls-$FP" ]; then
  echo "" >&2
  echo "STOP GATE: database files changed and this change set has no RLS audit:" >&2
  rr_db_files | sed 's/^/  /' >&2
  echo "Run the rls-auditor agent, fix critical findings, then: .claude/hooks/mark-reviewed.sh rls" >&2
  BLOCK=1
fi

if [ -n "$(rr_code_files)" ] && [ "${SKIP_CODE_REVIEW_GATE:-0}" != "1" ] && [ ! -f "$DIR/code-$FP" ]; then
  echo "" >&2
  echo "STOP GATE: code changed and this change set has no passing code review:" >&2
  rr_code_files | sed 's/^/  /' >&2
  echo "Run the code-reviewer agent. On APPROVE or APPROVE WITH NITS: .claude/hooks/mark-reviewed.sh code" >&2
  echo "On REQUEST CHANGES: fix, then review again." >&2
  BLOCK=1
fi

[ "$BLOCK" = "1" ] && exit 2
exit 0
