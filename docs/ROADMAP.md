# Roadmap
Current version: none (pre-v0.1.0) | Current phase: 0 | Updated: 2026-11-22
Repo: https://github.com/parentalai/gta6-stats (public) | Design: `docs/BRIEF.md` | State: `docs/HANDOFF.md`

Status: `[ ]` not started · `[~]` in progress · `[!]` waiting/blocked (reason given) · `[x]` done (date, PR). Task IDs are stable and never reused.

> **Urgency:** rarity history cannot be backfilled and moves fastest in launch week (game out 2026-11-19). P0 is kept minimal so P1 collectors start as early as possible; P1-00 lets a crude collector start even before the full pipeline exists.

---

## Now: Phase 0, v0.1.0: Bootstrap and pipeline
Goal: a resumable public repo with CI, a Cloudflare account, and a hello-world Pages + Worker deploy.

### Your build steps (do in this order; full instructions in `docs/runbooks/accounts.md`)
1. [~] P0-02 Cloudflare: account exists (lab identity). Left: confirm 2FA, pick a neutral `*.workers.dev` subdomain, run `wrangler login` + `wrangler whoami` in your terminal, tell Claude the account ID (not secret) → runbook Step 1
2. [ ] P0-03a Xbox: OpenXBL API key using the lab Microsoft account (not personal) → runbook Step 2; tell Claude the free-plan request limit
3. [ ] P0-03b PlayStation: new throwaway PSN account (new e-mail, no payment, never on your PS5), NPSSO token kept in your password manager → runbook Step 3
4. [ ] P0-04 Approve the stack ADR (P0-06) and each npm dependency it lists
5. [ ] P0-13 Later (when the Worker exists): `wrangler secret put OPENXBL_API_KEY` / `PSN_NPSSO` → runbook Step 4

### Claude: next up (in order)
- [~] P0-00 Session bootstrap: all files committed and pushed. Left: confirm the SessionStart hook printed the handoff after the owner's `/clear` (2026-11-22); then mark done
- [ ] P0-05 ADR-0002 Cloudflare free tier as the platform (Pages, Workers + Cron, D1); quota table
- [ ] P0-06 ADR-0003 Stack: frontend framework + chart library, TypeScript, test runner, package manager (each dependency proposed for approval)
- [ ] P0-07 ADR-0004 Read path under viral load (R2 vs KV vs static redeploy), with a quota estimate for 1M page views/day
- [ ] P0-09 GitHub repo settings: branch protection, secret scanning + push protection, Dependabot, CodeQL, PR template, release-please
- [ ] P0-10 CI workflow: lint, type-check, tests, build; deploy Pages + Worker on merge, preview deploys on PR (scoped Cloudflare API token)
- [ ] P0-11 Hello-world: Pages site with disclaimer + Worker with a cron that writes a heartbeat row to D1
- [ ] P0-12 Phase close: LEARNING (Pages, Workers, Cron Triggers, D1, edge cache), release notes, tag **v0.1.0**, handoff

---

## Next: Phase 1, v0.2.0: Trophy collectors and history
- P1-00 Stopgap collector: if P0 slips, a local script (run by you on a schedule) snapshots rarity to CSV so launch-week history is not lost; imported into D1 later
- P1-01 Spike: OpenXBL/Xbox endpoint for title-wide achievement rarity; limits; fixture recorded
- P1-02 Spike: `psn-api` trophy rarity for GTA VI read via a public profile that played it (throwaway must not need ownership), `trophyEarnedRate` field present?, GTA VI npCommunicationId (`trophy2`/PS5), runs in a Worker?, NPSSO/refresh lifetime; fixture recorded
- P1-03 D1 schema + migrations: trophies, rarity_snapshots, milestones, collector_runs
- P1-04 Xbox collector (cron), with retries/backoff and run log
- P1-05 PSN collector (cron), refresh-token handling, NPSSO-expiry alert
- P1-06 JSON publisher: `latest.json` + per-trophy history per the read-path ADR
- P1-07 Staleness/health check and alerting (free: e-mail or GitHub issue)
- P1-08 `data/stat-definitions.json` v1 (Pipework/Mandy's sink, story completion, Platinum race...) + `docs/methodology.md`
- P1-09 Curated denominator milestones (Take-Two sales figures with sources)

## Later
- Phase 2, v0.3.0: Public dashboard MVP (stat tiles, rarity race charts, sink counter with "show the math", spoiler toggle, methodology page, accessibility pass)
- Phase 3, v0.4.0: Shareability and live feel (OG share cards, deep links, auto-refresh, milestone banners, embeds)
- Phase 4, v0.5.0: More feeds (Twitch viewers, YouTube views, Rockstar service status/Newswire, sales milestones)
- Phase 5, v0.6.0: Community (Reddit buzz, crowd "I did this" counters with Turnstile)
- Phase 6, v1.0.0: Name, domain, launch

## Backlog
- PS vs Xbox "which side is faster" comparisons — strong share bait
- "First Platinum" watch: alert when Platinum rarity leaves 0.00% — biggest viral moment of launch month
- Trophy speed curves (days since launch to reach X%) — the over-time story
- GTA Online / DLC countdowns once announced
- Weekly auto-generated "this week in numbers" post/image — drives return visits

## Done
- [x] P0-01 Public repo https://github.com/parentalai/gta6-stats created, `main` pushed; repo-local identity parentalai (noreply e-mail); `.gitattributes` LF (2026-11-22)
- [x] P0-08 `docs/runbooks/accounts.md`: Cloudflare, OpenXBL (lab Microsoft account), throwaway PSN + NPSSO, secret storage and rotation (2026-11-22)
