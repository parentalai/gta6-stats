# Project Brief: GTA 6 Stats Dashboard (working title)

> This brief is the design source of truth. `docs/ROADMAP.md` tracks progress against it, and `docs/HANDOFF.md` carries state between sessions. If the brief and reality disagree, Claude proposes a brief update rather than silently drifting.

## 1. What we are building

A free, public, fan-made dashboard of fun, surprising and shareable stats about Grand Theft Auto VI (released 2026-11-19 on PS5 and Xbox Series X|S), tracked over time so people come back to watch the numbers move.

Examples of the stats people latch onto:
- "Mandy's sink has been fixed ~N times." (Pipework mission completions, estimated from trophy rarity × player estimate.)
- "Only X% of players have finished the story", "the race to the first Platinum", "the rarest trophy right now".
- Day-by-day curves of how fast players move through the game, PlayStation vs Xbox.

**v1 data source: trophy and achievement rarity only** (decided 2026-11-22). Other feeds (Twitch, YouTube, Rockstar status/news, Reddit, community counters) are later phases.

## 2. Guiding principles

1. **Free.** Every hosted component runs on a free tier (Cloudflare first). No paid services; ask before adding any dependency that is not free and open source.
2. **History starts when the collector starts.** Rarity moves fastest in launch week and cannot be backfilled. Collecting data comes before UI polish.
3. **Honest numbers.** Every derived stat shows its math ("Chapter 1 trophy 41% × 32.5M copies sold ≈ …") and is labelled *estimate*, *measured* or *community*. Sources and the time of the last update are always visible.
4. **Fun and friendly.** Mobile-first, loads fast, big readable numbers, plain-language captions, shareable (per-stat share cards and links). Accessible (WCAG AA contrast, works without colour alone, keyboard and screen-reader friendly).
5. **As real time as the data allows.** Collect as often as the sources and free-tier limits allow; the page updates itself without a reload.
6. **Survive going viral.** The read path is static or edge-cached, so a traffic spike costs nothing and cannot exhaust free-tier quotas.
7. **Small, versioned increments.** Each phase ships a tagged release that runs.

## 3. Legal, ethics and safety constraints

- Unofficial fan site. A visible "Not affiliated with or endorsed by Rockstar Games, Take-Two, Sony or Microsoft" disclaimer. No Rockstar logos, artwork, or imitation of Rockstar's branding or typography. Game and trademark names only as plain-text references.
- No player is singled out: we publish only aggregate rarity. Gamertags/PSN IDs used to read rarity are never displayed or stored beyond what the collector needs.
- PSN access uses the unofficial `psn-api` library with a dedicated throwaway PSN account (a terms-of-service gray area: read-only, low volume, accepted by the owner 2026-11-22). If Sony objects or the account is blocked, Xbox data continues alone.
- Respect each source's rate limits and terms; back off on errors; identify with a generic client name.

## 4. Data sources

### 4.1 Xbox achievements (official)
- **OpenXBL** (xbl.io, free tier, API key) or the Xbox Web API. Achievement objects carry `rarity.currentPercentage` and `rarity.currentCategory`.
- UNVERIFIED (spike P1-01): which endpoint returns title-wide rarity, whether it needs a profile that owns the game, and free-tier request limits.

### 4.2 PlayStation trophies (unofficial)
- **`psn-api`** (npm, MIT) authenticates with an NPSSO token from the throwaway account, exchanges it for access/refresh tokens, and reads trophy lists. Trophy objects carry `trophyEarnedRate` and `trophyRare`.
- UNVERIFIED (spike P1-02): whether rarity requires the account to own/have played the game, whether it runs inside a Cloudflare Worker, and the token refresh lifetime (NPSSO expires roughly every two months, so the owner re-seeds it).

### 4.3 Denominator (how many players)
- Rarity is a % of players on that platform. Absolute counts ("fixed N times") need a player estimate: official Take-Two sales milestones (hand-curated with source links and dates, e.g. 32.5M sold before release, $3.79B day-one retail).
- The estimate method lives in one documented, versioned file (`docs/methodology.md`) and is shown on the page.

### 4.4 Mission ↔ trophy mapping
- A hand-curated `data/stat-definitions.json` maps fun stats to trophies (e.g. Pipework → the earliest trophy that requires it), with a caption, a formula, and a note on whether it is a lower bound. Reviewed in PRs like code. Spoiler level per stat; spoilers hidden by default.

## 5. Architecture (Cloudflare free tier)

```
 Cron Worker (collectors)  --->  D1 (SQLite: snapshots, history)
        |                                   |
        +--> builds latest.json + history ->+--> static JSON on the edge (cached)
                                                 |
 Cloudflare Pages (static site)  <---- fetches --+   (polls; no per-visitor DB reads)
```

- **Collector:** one Worker with Cron Triggers (free plan: up to 5 crons). Xbox and PSN collectors snapshot every trophy's rarity (start hourly; tighten if limits allow). Retries with backoff; a run log table; a staleness alarm.
- **Storage:** D1 tables for `trophies` (static list per platform), `rarity_snapshots` (platform, trophy, pct, captured_at), `milestones` (curated sales/denominator), `collector_runs`. ~55 trophies × 2 platforms × 24/day ≈ 2.6k writes/day, well inside free limits.
- **Read path (ADR in P0):** visitors must not hit D1 or count against the Workers 100k requests/day limit. Options: (a) cron writes JSON to R2 behind a custom domain with edge caching, (b) cron writes to Workers KV and Pages serves it, (c) a GitHub Action commits JSON and redeploys Pages (fully static, unlimited, but slower). Decide by measuring.
- **Frontend:** static site on Cloudflare Pages (`*.pages.dev` until a name/domain is chosen). Framework and charting library chosen by ADR (lean toward small: e.g. Vite + Preact or Astro, with uPlot or Chart.js). Polls `latest.json` with ETag/If-None-Match.
- **Share cards:** per-stat Open Graph images (generated at build/cron time, not per request).

## 6. Security baseline (public repo)

- Secrets never in the repo: `.env*`, `.dev.vars`, NPSSO and API keys gitignored from the first commit. The owner enters secrets themselves with `wrangler secret put` / `gh secret set`; Claude never sees, prints or logs a secret value.
- GitHub: secret scanning + push protection, Dependabot, CodeQL, branch protection on `main`. **No self-hosted runners on a public repo.**
- Cloudflare API token for CI scoped to only Pages + Workers + D1 of this account.
- Worker hardening: input validation on any write endpoint (none in v1), strict CSP and security headers on Pages, CORS limited to the site origin.

## 7. Development pipeline

### 7.1 Repo layout (target)
```
/web            static site (Cloudflare Pages)
/worker         collectors, cron, D1 migrations, JSON publisher
/data           stat-definitions.json, curated milestones
/scripts        session-context.sh and dev helpers
/docs           BRIEF, ROADMAP, HANDOFF, LEARNING, methodology, adr/, runbooks/, sessions/
/.claude        settings.json, commands
/.github        workflows, PR template, dependabot
```

### 7.2 Git and versioning
- GitHub flow: `main` always deployable; branch per task `feat/<task-id>-<slug>`; PRs for everything, even solo.
- Conventional Commits referencing the task ID; release-please for SemVer tags, CHANGELOG and releases.
- D1 schema changes only through Wrangler migrations reviewed in the PR.
- Decisions as ADRs in `docs/adr/`.

### 7.3 CI (GitHub-hosted runners only)
On PR: lint, type-check, unit tests (collector parsers tested against recorded fixtures, never live APIs), build, CodeQL, dependency audit. On merge to `main`: deploy Worker + Pages (preview deploys per PR), release-please.

## 8. Roadmap (phases; each ends in a tagged, running release)

0. **Bootstrap and pipeline** (v0.1.0): docs, hooks, commands, public repo, CI, Cloudflare account, hello-world deploy, read-path ADR.
1. **Trophy collectors and history** (v0.2.0): spikes (Xbox, PSN), D1 schema, cron collectors, run log, staleness alerts, JSON publisher. Start collecting ASAP.
2. **Public dashboard MVP** (v0.3.0): stat tiles, rarity race charts, sink counter with "show the math", disclaimer, methodology page.
3. **Shareability and live feel** (v0.4.0): share cards, deep links, auto-refresh, "just happened" milestones, embeddable widgets.
4. **More feeds** (v0.5.0): Twitch, YouTube, Rockstar service status and Newswire, curated sales milestones.
5. **Community** (v0.6.0): Reddit buzz, crowd "I did this" counters (Turnstile, rate limits).
6. **Name, domain and launch** (v1.0.0).

## 9. How Claude works on this project (CLI, frequent context clears)

Every session starts with no memory of the last one. Files carry all state:

| File | Role | Who changes it | How often |
|---|---|---|---|
| `docs/BRIEF.md` | Design source of truth | Claude proposes, owner approves | Rarely, by PR |
| `docs/ROADMAP.md` | Plan and progress | Claude writes freely | Every status change |
| `docs/HANDOFF.md` | State for the next session | Claude overwrites | End of every session, before every `/clear` |
| `docs/sessions/` | History of handoffs | Claude appends | Every handoff |
| `docs/adr/` | Decisions and why | Claude writes, owner approves | Per decision |
| `docs/LEARNING.md` | Concepts learned | Claude appends | When a new concept appears |
| `CLAUDE.md` | Rules and pointers | Claude proposes, owner approves | When a rule changes |

### 9.1 Every session
1. **Orient.** The `SessionStart` hook prints the handoff and the roadmap's "Now" section. State in three lines: where we are, what is next, what is blocked.
2. **Confirm** the one roadmap task (e.g. `P1-03`) before writing code.
3. **Work** on `feat/<task-id>-<slug>`; commit at every green point.
4. **Update `docs/ROADMAP.md`** as soon as a status changes or new work is found.
5. **Hand off** (`/handoff`) when the task is done, context is long, or before `/clear`.

### 9.2 Handoff format (`docs/HANDOFF.md`, overwritten, under ~80 lines)
```
# Handoff
Updated: <date time> | Branch: <branch> | Last commit: <short sha> <subject>
Phase: <n> <name> | Task: <ID> <title> | Status: <in progress / done / blocked>

## State in one paragraph
## Done this session
## In progress (exact files/functions, what is half-finished)
## Next steps (ordered; first one small and concrete)
## Blocked / waiting on the owner
## Decisions made (link ADRs)
## Gotchas and dead ends
## Verify current state (commands and expected result)
```
Each handoff is also saved as `docs/sessions/<YYYY-MM-DD>-<NN>-<task-id>.md`.

### 9.3 Roadmap format
Status markers: `[ ]` not started, `[~]` in progress, `[!]` blocked/waiting (reason), `[x]` done (date, PR). Task IDs are stable and never reused.

## 10. Open questions
1. Site name and domain (decide before v1.0.0; start on `*.pages.dev`).
2. Read-path design under viral load (R2 vs KV vs static redeploy), ADR in Phase 0.
3. Player-count denominator: sales only, or blend platform split estimates? Documented in `docs/methodology.md`.
4. Collection frequency each source tolerates on its free/unofficial access.
5. Which trophy best bounds each fun stat (e.g. Pipework), and how to show lower-bound vs estimate.
