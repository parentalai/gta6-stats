# ADR-0001: Record architecture decisions
Date: 2026-11-22 | Status: Accepted

## Context
The project is built across many short Claude Code sessions with frequent context clears. Decisions need to survive in files.

## Decision
Record significant decisions as short ADRs in `docs/adr/NNNN-title.md`: context, decision, consequences. Claude drafts them; the owner approves.

## Consequences
Decisions are reviewable in PRs next to the code. Reversing a decision means a new ADR that supersedes the old one.
