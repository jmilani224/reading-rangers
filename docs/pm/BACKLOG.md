# Backlog

Index of open work. One line per item; detail lives in `backlog-detail.md`. Managed by `/pm`.

Event starts **April 2027**.

## Now

- **Wrap 2026-11-10**: Repo scaffolding (`/pm`, `/ship`, review gate, backlog) added. Next session
  starts with **#1** (pick the frontend stack).

## Before launch

### Foundations
- **#1** Pick the frontend framework and how it talks to Supabase · Process · P0
- **#2** Pick hosting and domain (free tier) and wire deploys into `/ship` Step 7 · Process · P0 · Blocked by: #1
- **#3** App skeleton: framework, typecheck, lint, test scripts, CI green · Tech Debt · P0 · Blocked by: #1
- **#4** Data model and RLS: schools, classes, students, parent links, reading logs, donations · Feature · P0 · SPEC_NEEDED
- **#5** Email sign-in with Supabase Auth (Google/Apple later) · Feature · P1 · Blocked by: #3

### Families and reading
- **#6** Class codes link parents to their children · Feature · P1 · SPEC_NEEDED · Blocked by: #4
- **#7** Log reading minutes, goals and progress · Feature · P1 · SPEC_NEEDED · Blocked by: #4
- **#8** Teacher sessions count toward student goals · Feature · P2 · Blocked by: #7

### Donations
- **#9** Test Zeffy: does a student-name custom field come through the API/webhook? · Open Question · P0
- **#10** Donation flow and payment webhook (Zeffy, or Stripe fallback) · Feature · P1 · SPEC_NEEDED · Blocked by: #9, #4

### Leaderboards and comms
- **#11** Leaderboards (signed-in only): readers by class/grade/school, donations by class/grade · Feature · P1 · SPEC_NEEDED · Blocked by: #7, #10
- **#12** Email reminders and transactional email provider · Feature · P2 · Blocked by: #5

### Admin
- **#13** School and roster setup, PTA lead roster sign-off · Feature · P1 · SPEC_NEEDED · Blocked by: #4
- **#14** Sponsor pages, tiers and emailed click reports · Feature · P2 · SPEC_NEEDED

### Design
- **#15** Visual design and branding with Ashley and Aaron · Design · P2

## Waiting on PTA

- **#16** Replies on the requirements doc (doc written 2026-11-06; no reply as of 2026-11-10) · PTA Decision · P1

## After launch

- Google and Apple sign-in, if not done before launch · Feature · P4
- Roll out to the other district elementary schools · Process · P4

## Recently completed

- 2026-11-10 · Repo scaffolding: `/pm`, `/ship`, code-reviewer, rls-auditor, review gate, backlog
