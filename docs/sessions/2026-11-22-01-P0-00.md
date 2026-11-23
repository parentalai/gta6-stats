# Handoff
Updated: 2026-11-22 | Branch: main (local only, no remote yet) | Last commit: chore(P0-00): bootstrap repo, docs and session protocol
Phase: 0 Bootstrap and pipeline | Task: P0-00 Session bootstrap | Status: done except the /clear hook test

## State in one paragraph
New project for a free, public, fan-made GTA VI stats dashboard (game released 2026-11-19). Owner decisions (2026-11-22): v1 tracks PlayStation trophy and Xbox achievement rarity only (Xbox via OpenXBL, PSN via the unofficial `psn-api` with a throwaway account); hosting on Cloudflare free tier (Pages + Workers Cron + D1); public repo under the parentalai GitHub identity; same docs/session protocol as the SOC project with lighter CI; site name decided later. Repo is initialised locally with docs, hook and commands; nothing is deployed and no accounts exist yet. Urgency: rarity history can't be backfilled, so collectors should start as early as possible.

## Done this session
- Researched data availability: Rockstar has no stats API (status page HTML, Newswire only); trophy/achievement rarity is the real source; Twitch/YouTube/Reddit for later phases
- Created BRIEF, CLAUDE.md, ROADMAP, HANDOFF, LEARNING, ADR-0001, `.gitignore`, `.claude/settings.json` (SessionStart hook, deny reads of secret files), `scripts/session-context.sh`, commands `/handoff` `/resume` `/roadmap` `/phase-start` `/phase-close`
- `git init` with repo-local identity parentalai + GitHub noreply email; first commit

## In progress
- P0-00: `/clear` test that the SessionStart hook shows this handoff

## Next steps
1. Owner runs `/clear`; confirm the handoff appears (closes P0-00)
2. P0-01 owner approves repo name (working `parentalai/gta6-stats`) → `gh repo create --public`, push
3. P0-05/06/07 ADRs (platform, stack + deps for approval, read path)
4. P0-08 accounts runbook so the owner can create Cloudflare/OpenXBL/PSN accounts in parallel
5. Consider P1-00 stopgap collector early if P0 drags on

## Blocked / waiting on the owner
- P0-01 repo name/creation · P0-02 Cloudflare account + `wrangler login` · P0-03 OpenXBL key, PSN throwaway + NPSSO · P0-04 stack and dependency approvals

## Decisions made
- ADR-0001 record decisions. Platform/stack/read-path ADRs pending (P0-05..07)

## Gotchas and dead ends
- No official GTA VI Social Club stats; Rockstar status page has no documented JSON API
- "Live player count" sites are estimates; Take-Two sales (32.5M pre-release) and Circana are the credible figures
- Wrangler 4.90.0 is already installed globally (not installed by Claude); Node 24.15, gh 2.105 signed in as parentalai

## Verify current state
- `git log --oneline` → one bootstrap commit
- `bash scripts/session-context.sh` → prints this handoff, roadmap "Now", git status
