---
description: Write the session handoff (HANDOFF.md + sessions/ copy) and update the roadmap
---
Write the handoff per `docs/BRIEF.md` section 9.2:
1. Update `docs/ROADMAP.md` statuses (date, PR) for anything that changed this session.
2. Overwrite `docs/HANDOFF.md` in the exact 9.2 format, under ~80 lines. Fill "Verify current state" with real commands and expected results. Record dead ends so they are not retried.
3. Save a copy as `docs/sessions/<YYYY-MM-DD>-<NN>-<task-id>.md` (NN = next number for today).
4. Commit the docs on the current branch: `docs(<task-id>): handoff`.
5. Reply with the three-line summary: where we are, what's next, what's blocked.
