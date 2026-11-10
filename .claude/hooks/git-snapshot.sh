#!/usr/bin/env bash
# PreToolUse(Bash) hook — snapshot before a destructive git command.
#
# Why this exists: a `git checkout`/`reset`/`clean` can silently discard uncommitted work.
# Carried over from the ChessGo repo, where exactly that cost a fix that had to be rewritten.
#
# Design note: this deliberately does NOT use `git stash push`, which MUTATES the working
# tree and would change the meaning of the very command about to run. `git stash create`
# builds a commit object and leaves the tree untouched; `update-ref` keeps it from being
# garbage-collected. The hook is non-blocking: it snapshots and gets out of the way.
#
# Recover with:  git stash apply <sha>   or   git show <sha>
# List with:     git for-each-ref refs/snapshots
set -uo pipefail

payload="$(cat)"
cmd="$(printf '%s' "$payload" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)"
[ -z "$cmd" ] && exit 0

# Destructive to TRACKED content. (checkout/reset/restore/stash drop do not touch untracked files.)
tracked_re='git[[:space:]]+(checkout([[:space:]]+-f)?[[:space:]]+(--|\.)|checkout[[:space:]]+-f|restore([[:space:]]|$)|reset[[:space:]]+(--hard|--merge|--keep)|stash[[:space:]]+(drop|clear|pop))'
# Destructive to UNTRACKED content as well.
untracked_re='git[[:space:]]+clean[[:space:]]+[-a-zA-Z]*f'

hits_tracked=false; hits_untracked=false
printf '%s' "$cmd" | grep -Eq "$tracked_re"   && hits_tracked=true
printf '%s' "$cmd" | grep -Eq "$untracked_re" && { hits_tracked=true; hits_untracked=true; }
[ "$hits_tracked" = false ] && exit 0

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
# Nothing to lose?
if [ -z "$(git status --porcelain)" ]; then exit 0; fi

ts="$(date +%Y%m%d-%H%M%S)"
snap="$(git stash create "pre-destructive snapshot $ts" 2>/dev/null)"
if [ -n "$snap" ]; then
  ref="refs/snapshots/$ts-$(printf '%s' "$snap" | cut -c1-7)"
  git update-ref "$ref" "$snap" 2>/dev/null
  echo "[git-snapshot] tracked changes saved: $snap ($ref) — recover: git stash apply $snap" >&2
fi

if [ "$hits_untracked" = true ]; then
  outdir="$(git rev-parse --git-dir)/snapshots"; mkdir -p "$outdir"
  out="$outdir/untracked-$ts-$$.tar.gz"
  if git ls-files --others --exclude-standard -z | grep -qz .; then
    git ls-files --others --exclude-standard -z | tar --null -czf "$out" -T - 2>/dev/null \
      && echo "[git-snapshot] untracked files archived: $out" >&2
  fi
fi
exit 0
