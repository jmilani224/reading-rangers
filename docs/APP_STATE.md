# App state

What is actually built today. Update it in the same PR as any change to what users can do.

_Last updated: 2026-11-10_

## Built

- App skeleton (#3): a Vite + React + TypeScript single-page app with one placeholder page
  ("Coming April 2027"). It reads the Supabase URL and anon key from `VITE_` settings and shows a
  setup error on the page when they are missing. No sign-in, data or other screens yet.
- Project workflow: `/pm`, `/ship`, `/designer`, the code-reviewer and rls-auditor agents, the
  review gate (stop hook and CI job), and the backlog.

## Not built

Everything in `docs/pm/REQUIREMENTS.md`.
