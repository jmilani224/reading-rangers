# CLAUDE.md

Guidance for Claude Code working in this repository.

## Project

**Reading Rangers** is a web app that runs an annual read-a-thon for elementary schools in one
district. Families log reading minutes for their K-5 children, sponsors make flat donations that
go to each school's PTA, and classes, grades and schools follow leaderboards. It replaces
read-a-thon.com, which took $3k of last year's $10k.

- First event: **April 2027**. One school (under 300 students) to start, up to seven district
  elementary schools later. **Multi-school from day one**: schools differ only by name; branding
  is shared district-wide.
- Low cost is a requirement: free tiers wherever they work, about $10/month for the database,
  about $20/year for the domain.
- Product requirements: https://claude.ai/artifact/J8uv6azeECLYa4t22dbT2A (its "Decisions so far"
  section wins). Repo summary: `docs/pm/REQUIREMENTS.md`.

## Stack

- **Backend**: Supabase (Postgres, Auth, Row Level Security, edge functions as needed). Joel has
  a Supabase Pro plan.
- **Frontend**: React + TypeScript, built with Vite, as a static single-page app (decided
  2026-11-10, backlog #1). The browser talks to Supabase directly with `supabase-js` and the
  signed-in user's session, so **RLS is the security boundary**: never put the `service_role` key
  or an authorization check that only the UI enforces in this code. Anything that needs a secret
  or must run server-side (payment webhooks, scheduled emails, privileged writes) goes in a
  Supabase edge function or a Postgres function.
  - Why: nearly every page is behind sign-in, so server rendering buys little; a static app is the
    cheapest to host and has no server to secure; React has the widest pool of help and leaves a
    path to React Native if an iPhone app is ever wanted.
  - Rejected: Next.js (adds a server to run and secure; Vercel's free Hobby plan is non-commercial),
    SvelteKit (fewer libraries), Fly.io hosting (runs and bills a server we do not need).
- **Hosting**: Cloudflare Pages free tier (allows commercial use), deploying from GitHub on merge
  to `main`. Joel has a Cloudflare account. Setup, domain and the `/ship` deploy step are backlog #2.
- **Payments**: Zeffy is the leading choice (free to nonprofits, API + webhook), pending a test that
  a student-name field comes through. Stripe is the fallback.
- **Email**: transactional email for sign-in and reminders; provider not chosen yet.

## Workflow

- `/pm`: backlog intake, what's next, specs, end-of-session wrap. Backlog: `docs/pm/BACKLOG.md`.
- `/ship`: checks, required code review, PR, merge, migrations, deploy check.
- **Code review is a gate, not a suggestion.** The `code-reviewer` agent (and `rls-auditor` for DB
  changes) must pass before merge. Two things enforce it:
  - `.claude/hooks/stop-gate.sh` (Stop hook) blocks the end of a turn while the branch has code
    changes with no recorded passing review for the current diff.
  - The CI job **Code review gate** fails a PR that changes code without a
    `Code review: APPROVE @ <head sha>` line in its description. Make it a required check on `main`.
- One commit per PR (squash merge). Stage files explicitly; never `git add -A`.
- `docs/APP_STATE.md` describes what is built today. Update it in the same PR as any change to
  what users can do.

## Rules for every session

1. **Child data is private by default.** A parent sees only their linked children; a teacher only
   their class; a school admin only their school. Public pages show at most first name and last
   initial and never reading logs. Leaderboards require sign-in.
2. **Every table has RLS** with least-privilege policies keyed on `auth.uid()`. No `USING (true)`
   on anything but deliberately public data. Authorization is never only in the UI.
3. **Every row that belongs to a school carries `school_id`**, and every query and policy is
   scoped by it, even while only one school exists.
4. **Never trust the client** for a user id, student id, school id, role or amount. Validate every
   write on the server or in the database.
5. **Money comes from the payment provider.** Webhooks are signature-verified and idempotent;
   totals are derived from recorded payments, never typed in the browser.
6. **Business rules live in one place** (goal math, totals, ranking, event-window checks), as pure
   functions with unit tests. Pages display; they do not compute.
7. **Migrations are expand-then-contract.** Never drop or rename something the deployed code still
   reads. Security advisor shows zero ERRORs before a production migration.
8. **Secrets stay out of the repo and out of the browser.** The `service_role` key is server-only.
9. **Mobile first.** Most parents will log minutes on a phone.
10. **Fail loudly.** No swallowed errors; every page has loading, empty and error states.
11. **No stated number that was not computed with a tool.** Durations, counts and costs in
    reports, specs and commits come from a command, not mental arithmetic. A claim about control
    flow ("runs before", "cannot happen") cites the `file:line` that makes it true, or says
    unverified.
12. Files over 500 lines get a note in the PR on why they were not split.

## What goes where

Fill in the module paths when the app skeleton lands (backlog #3). The intended split:

| Layer | Responsibility |
|-------|----------------|
| `supabase/migrations/` | Schema, RLS policies, database functions |
| `supabase/functions/` | Webhooks (payments), scheduled emails |
| shared logic module | Pure business rules and constants, unit-tested |
| pages / components | Display and interaction only |
