# Backlog detail

Full rows for open items that need more than a line. Search for `| N |`.

| # | Item | Detail |
|---|------|--------|
| 4 | Data model and RLS | Multi-school from day one: every school-owned row has `school_id`. Core tables: schools, classes, students, parent-child links, teacher-class links, reading logs, donations, sponsors. RLS policies and isolation tests (two parents, two classes, two schools) are part of the item, not a follow-up. |
| 9 | Zeffy test | Zeffy is free to nonprofits and has a read-only API and a `payment.completed` webhook. The open question is whether a custom student-name field arrives on the payment record. If not, Stripe is the fallback. Needs a test campaign on the PTA's Zeffy account or a sandbox. |
| 16 | PTA replies | Questions are in the PTA summary doc (https://claude.ai/artifact/C3sHWqpBAUJf9nwkKZ8Nob). Building continues on the decisions already made. |
