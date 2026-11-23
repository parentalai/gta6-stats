---
description: Show roadmap status, or update it ($ARGUMENTS = e.g. "P1-03 done PR #7" or "add backlog: ...")
---
If `$ARGUMENTS` is empty: summarise `docs/ROADMAP.md`: current phase, counts by status, waiting-on-owner items, next three Claude tasks.
Otherwise apply the change described in `$ARGUMENTS` to `docs/ROADMAP.md` using the status markers and stable task IDs (never reuse an ID; new tasks get the next free number in their phase), update the "Updated:" date, and show the diff.
