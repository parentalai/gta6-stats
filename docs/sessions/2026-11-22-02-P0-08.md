# Handoff
Updated: 2026-11-22 | Branch: main (after merging docs/P0-08-accounts-runbook) | Last commit: docs(P0-08): accounts runbook, owner build steps, handoff
Phase: 0 Bootstrap and pipeline | Task: P0-00 hook test, then owner build steps | Status: waiting on owner (accounts)

## State in one paragraph
Free, public, fan-made GTA VI stats dashboard (game out 2026-11-19). v1 = PlayStation trophy + Xbox achievement rarity turned into shareable stats ("Mandy's sink fixed ~N times"), tracked over time. Hosting: Cloudflare free tier (Pages + Workers Cron + D1). Public repo https://github.com/parentalai/gta6-stats is live with docs, SessionStart hook and slash commands; no code, no deploy yet. The owner is now doing the account steps in `docs/runbooks/accounts.md` (roadmap "Your build steps"). Urgency: rarity history can't be backfilled, so start collectors as soon as keys exist (P1-00 stopgap if P0 drags).

## Done this session
- Bootstrap docs, hook, commands; `.gitattributes` LF; repo created public and pushed (P0-01)
- `docs/runbooks/accounts.md` (P0-08): Cloudflare (existing lab-identity account), OpenXBL via lab Microsoft account, throwaway PSN account + NPSSO, secret storage (`wrangler secret put`), rotation
- Roadmap: "Your build steps" section in order; P1-02 spike rewritten (read rarity via a public profile so the throwaway needn't own the game)

## In progress
- P0-00: the owner ran `/clear` to test the hook. **First thing this session: confirm the SessionStart output showed this handoff, then mark P0-00 `[x]`.**

## Next steps
1. Confirm hook test → P0-00 done (commit on a branch + PR)
2. Ask the owner the status of build steps 1-3 (Cloudflare `wrangler whoami` account ID, OpenXBL free limit, PSN NPSSO stored)
3. P0-05/06/07 ADRs (platform, stack + deps for approval, read path); P0-06 is the gate for any code
4. P0-09 repo security settings, P0-10 CI, P0-11 hello-world deploy
5. If keys arrive before P0 finishes: jump to P1-01/P1-02 spikes and P1-00 stopgap so history starts

## Blocked / waiting on the owner
- P0-02 Cloudflare 2FA check + `wrangler login` · P0-03a OpenXBL key · P0-03b throwaway PSN + NPSSO · P0-04 stack/dependency approvals

## Decisions made
- ADR-0001 record decisions. Owner choices 2026-11-22: v1 rarity only; Xbox via OpenXBL + PSN via unofficial `psn-api` (ToS gray area accepted, throwaway account); Cloudflare; public repo under parentalai; name later
- Owner does not want the personal PSN/Xbox accounts linked; use the lab identity or throwaway accounts only
- Never write the owner's e-mail addresses into this public repo

## Gotchas and dead ends
- G: has no ownership info: git needed `safe.directory` for this path (added to global git config)
- Unverified: OpenXBL free-plan limit and rarity endpoint (P1-01); `psn-api` `trophyEarnedRate` field and whether non-owners can read rarity (P1-02)
- No official GTA VI stats API; Rockstar status page is HTML only; "live player count" sites are estimates
- Wrangler 4.90.0 already installed globally (not by Claude); Node 24.15; gh signed in as parentalai

## Verify current state
- `git log --oneline -3` → docs(P0-08) on top of the two P0-00 commits; `git status` clean
- `gh repo view parentalai/gta6-stats --json visibility` → PUBLIC
- `bash scripts/session-context.sh` → prints this handoff + roadmap "Now"
