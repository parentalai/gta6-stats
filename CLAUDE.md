# GTA 6 Stats Dashboard (working title)

Free, public, fan-made dashboard of fun GTA VI stats tracked over time. v1 = PlayStation trophy and Xbox achievement rarity, turned into shareable "omg" stats (e.g. "Mandy's sink fixed ~N times"). Hosted on Cloudflare free tier.

## Where things are
- Design source of truth: `docs/BRIEF.md` (read only the section a task needs)
- Plan and progress: `docs/ROADMAP.md` | Session state: `docs/HANDOFF.md` | Decisions: `docs/adr/`
- How estimates are computed: `docs/methodology.md` (from Phase 1)

## Session protocol (BRIEF 9)
1. Orient from the SessionStart output: where we are, what's next, what's blocked (3 lines).
2. Confirm the one roadmap task (e.g. `P1-03`) before writing code.
3. Branch `feat/<task-id>-<slug>`; Conventional Commits that reference the task ID.
4. Update `docs/ROADMAP.md` as soon as a status changes.
5. `/handoff` before any `/clear` or when the task is done.

## Hard rules
- **Never install, upgrade or uninstall any tool, software, package, extension, container image or dependency without the owner's explicit approval for that specific item in chat.** Propose it (name, source, licence, why) and wait for a yes. This includes adding npm dependencies to a package.json. A general "go ahead" is not approval to install.
- **Public repo.** Never commit secrets, tokens, NPSSO values, `.env*` or `.dev.vars`. Never ask for, read, print or log a secret value: the owner runs `wrangler secret put` / `gh secret set` themselves. No self-hosted GitHub runners.
- **Fan site.** No Rockstar logos, artwork or imitation of Rockstar branding; keep the "not affiliated" disclaimer on every page.
- **Honest numbers.** Every derived stat shows its formula and source, and is labelled estimate / measured / community.
- **Privacy.** Publish aggregate rarity only; never display or store gamertags/PSN IDs beyond what a collector needs.
- **Free only.** Stay inside Cloudflare/GitHub free tiers; check quotas before adding a request path. Ask before any non-free or non-open-source dependency.
- Tests against recorded fixtures, never live APIs in CI.
- Explain new Cloudflare/web concepts in 2-3 sentences and append them to `docs/LEARNING.md`.

## Commands
(Filled in as the stack is built.)
