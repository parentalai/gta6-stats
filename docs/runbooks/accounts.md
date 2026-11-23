# Runbook: accounts and keys for the build (owner steps)

You do every step here yourself. Claude never sees a key, token or password: **never paste one into chat, a file in this repo, or a commit.** Keep each value in your password manager until the step that stores it in Cloudflare (`wrangler secret put`, Step 4), which Claude will tell you when to run.

Identity rule: nothing here uses your personal Microsoft, Xbox, Sony or PSN accounts. Xbox uses the lab identity (parentalai); PSN uses a new throwaway account. Collectors run on Cloudflare's servers, so no request comes from your home IP.

Order: Step 1 → 2 → 3 can be done in parallel; Step 4 waits until the Worker exists (Phase 1).

---

## Step 1: Cloudflare (P0-02) — account already exists (lab identity)
1. Sign in at https://dash.cloudflare.com. **Profile → Authentication:** confirm two-factor authentication is on (authenticator app or security key). Save the backup codes offline.
2. **Workers & Pages:** open it once and pick your `*.workers.dev` subdomain if asked. It is public and appears in URLs, so use something neutral (e.g. `gta6-stats`), never your name.
3. Confirm the plan says **Free**. Do not add a payment method.
4. In **your own terminal** (PowerShell, in this repo folder):
   ```
   wrangler login     # opens the browser; approve access for this account
   wrangler whoami    # should show the lab account and its account ID
   ```
   The account ID is not a secret; you can tell Claude it (needed for `wrangler.toml`).
5. Tell Claude "P0-02 done".

## Step 2: Xbox API key via OpenXBL (P0-03a)
OpenXBL (https://xbl.io) is a free, unofficial wrapper around the Xbox Live APIs. You sign in with a Microsoft account that has an Xbox profile.
1. Use the **lab Microsoft account** (the parentalai Outlook account), not your personal one. If you'd rather keep even that separate, create a new free Outlook account first and use it below.
2. Sign in at https://www.xbox.com with that account. If prompted, create an Xbox profile with a neutral gamertag. No Game Pass, no console, no purchase needed.
3. Go to https://xbl.io → **Login with Xbox Live** → approve the permissions with the same account.
4. In your xbl.io profile/dashboard, create an **API key** (personal key). Copy it into your password manager as `OPENXBL_API_KEY`.
5. Note the **free plan request limit** shown on xbl.io (the number is not secret). Tell Claude the number. It decides how often the Xbox collector runs. *(Unverified: Claude could not confirm the current free limit or the exact rarity endpoint; spike P1-01 checks both.)*
6. Tell Claude "P0-03a done, free limit = N".

## Step 3: PlayStation token via a throwaway PSN account (P0-03b)
Sony has no public trophy API. The open-source `psn-api` library signs in with an **NPSSO** token: a 64-character session cookie from a signed-in Sony account. **The NPSSO is effectively that account's password.**

Why this works without your paid PS5 account: trophy rarity is global, so the collector can read it from the trophy list of *any* public profile that has played GTA VI. The throwaway account doesn't need the game, a console or PS Plus. *(Unverified until spike P1-02; if Sony requires ownership, we fall back to Xbox-only and decide then. Do not buy anything.)*

1. Create a new e-mail address used only for this (e.g. a new Outlook alias on the lab account or a new Proton address). Not your personal e-mail.
2. In a **private/incognito browser window**, go to https://www.playstation.com → **Sign in → Create account**. Use the new e-mail, an adult account, a neutral Online ID (not your name or gamertag), and **no payment method**.
3. Turn on 2-step verification (authenticator app) for the throwaway account. Save its backup codes with the password.
4. **Never sign in to this account on your PS5 or the PlayStation app on your phone, and never add your real account as a friend.** That is what would link the two identities.
5. Get the NPSSO, in the **same** browser window, while still signed in:
   - Open https://www.playstation.com and confirm you're signed in.
   - Open https://ca.account.sony.com/api/v1/ssocookie
   - The page shows `{"npsso":"<64 characters>"}`. Copy only the 64-character value into your password manager as `PSN_NPSSO`. If you get an error, sign in again or try another browser.
6. Close the private window. The NPSSO expires after a while (reported around two months). When the collector reports an expired token, repeat step 5 and update the secret. Phase 1 adds an alert for this (P1-05).
7. Tell Claude "P0-03b done".

Risk you accepted (BRIEF 3): reading PSN through an unofficial client is a terms-of-service gray area. The worst realistic case is that the throwaway account is blocked. Your real account is never involved.

## Step 4: storing the secrets in Cloudflare (later, when the Worker exists)
Claude will ask you to run these in your own terminal, from the `worker/` folder:
```
wrangler secret put OPENXBL_API_KEY     # paste from password manager at the hidden prompt
wrangler secret put PSN_NPSSO
wrangler secret list                    # shows names only, never values
```
Local development uses `worker/.dev.vars` (gitignored). You create that file yourself; Claude never reads it.

## Rotation and revocation
| Secret | Rotate when | How |
|---|---|---|
| `OPENXBL_API_KEY` | leaked, or yearly | xbl.io dashboard → delete key → create new → `wrangler secret put` |
| `PSN_NPSSO` | expiry alert, or leaked | sign out everywhere in the throwaway Sony account → steps 3.5 → `wrangler secret put` |
| Cloudflare login | leaked laptop | `wrangler logout`; dash → Profile → API Tokens → revoke |
| CI Cloudflare API token (P0-10) | yearly | dash → API Tokens → roll → `gh secret set CLOUDFLARE_API_TOKEN` |
