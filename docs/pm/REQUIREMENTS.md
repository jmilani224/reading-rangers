# Requirements summary

The full requirements doc is https://claude.ai/artifact/J8uv6azeECLYa4t22dbT2A and its "Decisions
so far" section is the source of truth. This is the repo's summary, as of 2026-11-10. The PTA has
not replied on the doc yet.

## Event
- Web app. First read-a-thon starts April 2027.
- K-5, under 300 students at the first school; up to seven district elementary schools later.
- Schools differ only by name. Logo, colors and design are shared district-wide.

## People and access
- **Parents/families**: email sign-in required (Google/Apple sign-in nice to have). A class code
  links a parent to their child.
- **Teachers**: can donate; see their own class only. Teacher reading sessions count toward
  students' goals.
- **Businesses/sponsors**: no login; emailed click reports; sponsor tiers wanted.
- **PTA project lead**: signs off the roster and runs the event.

## Reading and goals
- Families log reading minutes per child against a goal.
- Leaderboards only for signed-in users. Priority: top readers by class, grade and school;
  donations by class and grade; per-student donations optional.
- Rewards: reading at class/grade level, donating at student level. The PTA distributes them.

## Donations
- Flat donations, not per-minute. Money goes to the PTA (believed to be a 501(c)(3)).
- Zeffy leads (free to nonprofits, read-only API + `payment.completed` webhook), pending a test
  that a student-name custom field comes through on payments. Stripe is the fallback. Cheddar Up
  only via Zapier on its paid plan.

## Communication
- Email only for v1, including reminders.

## Constraints
- Low cost: free tiers where possible, about $10/month database, about $20/year domain.
- Joel has Supabase Pro and an Apple Developer account. Design help from Ashley and Aaron.
