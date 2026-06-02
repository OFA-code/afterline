# Where to put what (Afterline)

**One source of truth:** `config/business.json` — then run `node scripts/apply-config.mjs`

| What you need to set | File / place | Your value |
|----------------------|--------------|------------|
| Business email (leads, FormSubmit) | `config/business.json` → `businessEmail` | deallomcconnell@optimalflowagency.io |
| Gmail CC backup | `config/business.json` → `personalEmail` | deallomcconnell@gmail.com |
| Your name on emails | `config/business.json` → `operatorName` | Deallo |
| City / market | `config/business.json` → `city`, `state`, `region` | Hardy, AR |
| Pricing | `config/business.json` → `pilotPrice`, etc. | 497 / 997 / 1497 |
| Public API URL | `config/business.json` → `apiPublicUrl` | https://afterline-api.vercel.app |
| Vercel env (Twilio, secrets) | Vercel dashboard or `vercel env add` | apps/afterline project |
| Twilio SMS keys | `apps/afterline/.env` | empty until pilot client |
| Admin password | `apps/afterline/.env` → `ADMIN_SECRET` | set (do not share) |
| Outreach targets | `tools/LEAD-TRACKER.csv` | 10 leads loaded |
| Daily emails to send | `tools/outbox/` | copy into Outlook |

**Do NOT edit** `docs/` by hand — it mirrors `marketing/landing/` when you apply config.

**Booking page flow (live site):**
1. Visitor submits form on GitHub Pages
2. FormSubmit emails `businessEmail` (+ CC to Gmail)
3. You reply from Outlook within 2 hours

**When you get a pilot client:** run `scripts/setup-twilio.ps1`, add Twilio keys in Vercel env, set webhooks to `https://afterline-api.vercel.app/api/twilio/...`

**Note:** Vercel stores leads in memory per request — booking emails still fire via FormSubmit. Use local admin (`localhost:3847`) for full lead history.
