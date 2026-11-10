# Reading Rangers brand: the point of view

Exact tokens (colors, type scale, spacing, radius) will live in the frontend's theme file once it
exists. This file is the taste layer: who the app is for, how it should feel, and what it must
never do. **Decisions by Ashley and Aaron (the project's designers) override everything here.**

_Status 2026-11-10: no brand decisions made yet. Everything below marked "proposal" is Claude's
starting point for the designers to accept, change or reject._

## Who uses it

| Person | Where | What they need |
|--------|-------|----------------|
| **Parent / family** (most users) | Phone, evenings, often one-handed, often tired | Log minutes in seconds, see progress, share a donation link. Wide range of reading levels and some will read in a second language. |
| **Student (K-5)** | Beside a parent, or a classroom screen | Feel proud. Recognise their name, their class, their progress at a glance. Many cannot read yet. |
| **Teacher** | Laptop or classroom display, short gaps between lessons | Log a whole-class session fast; see their class only. |
| **PTA lead / school admin** | Laptop | Import a roster, check numbers, fix mistakes without fear. |
| **Sponsor / donor** | Phone, from a shared link, never signed in | Understand who they are supporting and give in under a minute. |

## How it should feel

- **Warm, proud, community.** A school event the whole family is part of, like a reading night in
  the school library, not a fundraising platform and not a video game.
- **Encouraging, never pressuring.** Progress is celebrated; falling behind is met with "every
  minute counts", never red warnings.
- **Calm and clear for adults, joyful in moments for kids.** Utility screens (forms, settings,
  admin) are plain and quiet. Delight is saved for moments that earn it: logging minutes, reaching
  a goal, the class moving up.
- **One district, many schools.** Shared district branding; a school's name is the only thing that
  changes. Never design something that needs per-school artwork.

## Proposals (pending Ashley and Aaron)

- **Name and mascot**: "Rangers" suggests exploring and trails: maps, badges, trail markers,
  campfire stories. A trail that fills as minutes are logged is a natural progress metaphor.
- **Palette**: a forest green or deep teal primary, a warm sunshine accent for celebration, a
  paper-white background. Every text and icon color pair meets WCAG AA (4.5:1 body, 3:1 large).
- **Type**: one friendly, highly legible sans (for example Atkinson Hyperlegible or Lexend, both
  free and designed for readability), at 16px minimum for body text.
- **Illustration**: simple, flat, inclusive; children of every background and ability. Badges
  earned at goals.

## Hard rules

1. **Never shame a child.** Leaderboards show top readers and celebrate classes; they never list
   the bottom, never show a child's rank outside the top group, and never show a single child's
   donation total to other families.
2. **Accessible by default.** WCAG 2.2 AA. 44px minimum tap targets. Color is never the only signal.
   Every action works by keyboard. Icons that matter have text labels.
3. **Phone first.** Every primary flow is designed at 375px wide before desktop.
4. **Child privacy is visible in the design.** Public and sponsor pages show at most a first name
   and last initial, no photos of children, no reading logs.
5. **Pre-readers can follow it.** Student-facing moments rely on pictures, numbers and color, not
   only words.
6. **Donations are invited, not pushed.** No countdown timers, guilt copy or pre-ticked upsells.
   The donation page says plainly that the money goes to the school's PTA.
7. **Every screen has its empty, loading and error state designed**, and every error says what to
   do next in plain words.

## Anti-patterns

- Fundraising-platform look: stock gradients, big thermometers, fee upsells.
- Kids'-app overload: every surface bouncing and confetti on every tap. Delight spent everywhere is
  noise.
- Gamification that ranks children against each other publicly.
- Dense admin-style tables on screens parents use.
- Raw colors or spacing in components instead of theme tokens.
- Copy written for adults on screens children read.

## Open for Ashley and Aaron

- Logo and mascot (does "Rangers" get a character?)
- Primary palette and typeface
- Illustration style and who produces it
- Badge and reward artwork for goal milestones
