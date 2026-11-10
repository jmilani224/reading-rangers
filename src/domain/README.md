# domain

Pure business rules and constants: goal math, totals, ranking, event-window checks, class code
parsing. No React, no network, no database. Each module has a `*.test.ts` beside it.
Pages call these; they do not compute.
