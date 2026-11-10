#!/usr/bin/env bash
# Shared helpers for the review gate. Sourced by stop-gate.sh and mark-reviewed.sh so both
# compute exactly the same change set and fingerprint.

# Every file this branch changes: committed-but-unmerged plus staged, unstaged and untracked.
rr_changed_files() {
  local base=""
  if git rev-parse --verify --quiet origin/main >/dev/null 2>&1; then
    base="$(git merge-base origin/main HEAD 2>/dev/null || true)"
  fi
  {
    git diff --name-only HEAD 2>/dev/null || true
    [ -n "$base" ] && { git diff --name-only "$base" HEAD 2>/dev/null || true; }
    git ls-files --others --exclude-standard 2>/dev/null || true
  } | grep -v '^$' | sort -u || true
}

rr_db_files()   { rr_changed_files | grep -E '^supabase/|\.sql$' || true; }
rr_code_files() { rr_changed_files | grep -E '\.(ts|tsx|js|jsx|mjs|cjs|sql)$|^supabase/functions/' | grep -vE '^\.claude/' || true; }

# Fingerprint of the CONTENT of the change, not just the file names. Any edit after a review
# changes the fingerprint and re-arms the gate. (ChessGo hashed file names only, so a review
# stayed "valid" through any number of later edits to the same files.)
rr_fingerprint() {
  local base=""
  if git rev-parse --verify --quiet origin/main >/dev/null 2>&1; then
    base="$(git merge-base origin/main HEAD 2>/dev/null || true)"
  fi
  {
    if [ -n "$base" ]; then git diff "$base" 2>/dev/null; else git diff HEAD 2>/dev/null; fi
    git ls-files --others --exclude-standard -z 2>/dev/null | xargs -0 -r cat 2>/dev/null
  } | sha256sum | cut -c1-16
}

rr_marker_dir() { echo "$(git rev-parse --git-dir)/claude-review"; }
