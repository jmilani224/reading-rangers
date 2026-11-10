# Reading Rangers

A web app for running an elementary school read-a-thon: families log reading minutes, sponsors
donate to the PTA, and classes compete on leaderboards. Built on Supabase.

- Project instructions for Claude Code: `CLAUDE.md`
- Backlog: `docs/pm/BACKLOG.md`
- What is built today: `docs/APP_STATE.md`

## Develop

Needs Node 22.

```bash
npm install
cp .env.example .env.local   # then fill in the Supabase URL and anon key
npm run dev                  # http://localhost:5173
npm run typecheck && npm run lint && npm test
```

## Workflow

- `/pm` in Claude Code to add, plan and wrap up work
- `/ship` to review, merge and release

Every code change needs a passing `code-reviewer` review before it merges. Turn on branch
protection for `main` with **Checks** and **Code review gate** as required status checks.
