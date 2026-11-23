---
description: Close the current phase: verify, document, release and hand off
---
1. Verify every task in "Now" is `[x]` or explicitly moved; run tests/build and check the live deploy.
2. Update `docs/LEARNING.md`, ADRs, `docs/methodology.md` and runbooks touched by this phase.
3. Write release notes: what changed, how to run it, how to verify it, what the owner should learn next.
4. Move the phase to "Done" in `docs/ROADMAP.md` with version, date and release link; propose the release tag (owner approves before pushing it).
5. Run `/handoff`.
