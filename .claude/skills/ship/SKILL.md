---
name: ship
description: Reading Rangers release workflow. Runs checks, the required code review gate, commit, PR, merge, database migrations and deploy verification, then updates the backlog. Will not merge code without a passing review of the exact commit being merged.
---

You are the Reading Rangers release assistant. When /ship is invoked, **do the release**: run the
commands, open the PR, merge it, apply migrations, check the deploy. Ask Joel before anything that
cannot be undone: the merge, a production migration, a tag.

Start with `git fetch origin main`, `git status --short` and `git diff --stat origin/main...HEAD`.

---

## Step 1: What is in this release?

| Category | Files |
|----------|-------|
| **App code** | `src/`, `app/`, `lib/`, `components/`, `package.json`, config files |
| **DB migration** | new files in `supabase/migrations/` |
| **Edge functions** | `supabase/functions/` |
| **Docs only** | `docs/`, `*.md`, `.claude/` |

**Does this change what the app does for a user?** If yes, update `docs/APP_STATE.md` in this
release, not after it. `/pm` reads that file before every spec, so a stale one leads to specs for
things already built.

---

## Step 2: Checks

Run whichever exist, and fix failures before going on:

```bash
npm run typecheck
npm run lint
npm test
```

Do not pipe a check whose exit code matters (`npm test | tail` reports `tail`'s success). CI runs
the same checks on the PR, but a failure found here costs a fix instead of a round trip.

---

## Step 3: The code review gate (required for any code)

**Skip only for docs-only releases.** Anything touching code, SQL or config gets a review, however
small.

1. Commit everything first, so the review covers exactly what will merge.
2. Run the reviewer and point it at the risk, not just the file list:

   ```
   Agent(subagent_type: "code-reviewer", prompt: "<what changed, and what to scrutinise: e.g.
   whether a parent can see another family's child, whether a replayed webhook double-counts>")
   ```

   Always ask it: can any role see data it should not (other families, classes, schools)? Can a
   total be miscounted? Can anything fail silently? Does it work on a phone?

3. If the release touches `supabase/` or any `.sql`, also run `rls-auditor`.
4. **Read the verdict line.**
   - `VERDICT: REQUEST CHANGES` or `VERDICT: FAIL`: fix the Critical and Warning findings, commit,
     and review again. Do not merge.
   - `VERDICT: APPROVE` / `APPROVE WITH NITS` / `PASS`: continue. Nits may ship as a follow-up
     backlog item; say so rather than letting them lapse.
5. Record the pass locally: `.claude/hooks/mark-reviewed.sh code` (and `rls` when audited). The
   stop hook checks these against a fingerprint of the diff, so any later edit re-arms it.
6. Note the commit you reviewed: `git rev-parse --short HEAD`.

**Any commit after the review needs a new review.** The CI gate checks the reviewed sha against
the PR head, so a fix pushed after review turns the gate red until it is reviewed again.

**Severity is decided by who can reach it.** A finding only an admin can trigger is real but does
not block a merge; file it. Do not run a third review round chasing narrower angles on the same
finding.

---

## Step 4: Commit, push, PR

```bash
git add <files>              # stage explicitly; never git add -A
git commit -m "type(scope): summary"   # with the Co-Authored-By footer the harness specifies
git push -u origin <branch>
```

Check for `gh` once: `command -v gh`. Cloud sessions use the GitHub MCP tools instead; only PR
creation and merging differ.

The PR description **must** contain the review lines the CI gate reads, one per line, starting at
the beginning of the line:

```
Code review: APPROVE @ <reviewed short sha>
RLS audit: PASS @ <reviewed short sha>        (only when DB files changed)
```

Use `APPROVE WITH NITS` when that was the verdict. Below them, summarise findings and what was
deferred. If you re-review after new commits, update these lines (editing the PR re-runs the gate).

**Never write a passing line the reviewer did not give.** The gate exists because a confident
self-report at the end of a long session is the thing it replaces.

---

## Step 5: Merge

1. Wait for CI: both **Checks** and **Code review gate** must be green. A red gate means the
   review is missing or stale; go back to Step 3, never edit the line to make it pass.
2. **Ask Joel to confirm the merge.**
3. Squash merge (`gh pr merge <n> --squash --delete-branch`, or the MCP merge tool with method
   `squash`), then `git checkout main && git pull`.

---

## Step 6: Database migrations

Order is always **merge, deploy, verify, migrate** for anything destructive, and additive
migrations (new tables, new nullable columns) may go first.

- Never drop or rename a column the deployed code still reads. Expand first (add the new thing,
  move the code), contract in a later release.
- Apply to a non-production Supabase branch or local stack first (`supabase db reset` locally).
- Run the Supabase security advisor after schema changes. Zero ERRORs before production.
- **Ask Joel before applying to production.** Then apply and confirm with the advisor again.

---

## Step 7: Deploy and verify

**Hosting is not chosen yet** (backlog). Until it is, there is no deploy step: the release ends at
the merge and any migration. When hosting is chosen, replace this section with the exact deploy
trigger, where to read its result, and a smoke check (load the home page, sign in, read one
class's leaderboard as a test parent).

Whatever the host: a green tick is not evidence. Read the log lines that say the new commit is
live, and load the page.

---

## Step 8: Close it out

Run the `/pm` hygiene for the shipped item: remove its line from `BACKLOG.md`, add it to Recently
completed with the date and PR number, and move its detail row to `completed-archive.md`. Commit
that on main or with the next change.

Report: what shipped, the PR, the review verdict, anything deferred.

---

## The stop gate

`.claude/hooks/stop-gate.sh` runs whenever Claude tries to end a turn with changes on the branch.
It runs typecheck, lint and test, and blocks until code-reviewer (and rls-auditor for DB changes)
has passed for the current diff. Bypasses, to be used sparingly and said out loud:
`SKIP_STOP_GATE=1`, `SKIP_CHECKS=1`, `SKIP_CODE_REVIEW_GATE=1`, `SKIP_RLS_AUDIT_GATE=1`.
