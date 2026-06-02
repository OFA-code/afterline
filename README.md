# Afterline · Optimal Flow Agency

**Field-service revenue recovery** — missed calls, estimates, reviews. Entry product alongside [ILRS at optimalflowagency.io](https://www.optimalflowagency.io).

## Start here

| Doc | When |
|-----|------|
| **[OPERATING-SYSTEM.md](OPERATING-SYSTEM.md)** | Master playbook — read first |
| **[30-DAY-PLAN.md](30-DAY-PLAN.md)** | Week-by-week targets |
| `scripts/daily-start.ps1` | Every morning — opens tracker, admin, playbook |

## Live links

- Landing: https://ofa-code.github.io/afterline/
- Book: https://ofa-code.github.io/afterline/book.html
- Email: deallomcconnell@optimalflowagency.io

## Config

Edit `config/business.json` (set **city** when you pick your market) → `node scripts/apply-config.mjs` → push.

## Folder map

| Path | Purpose |
|------|---------|
| `offer/` | Offer, pricing, ethics |
| `sales/` | Audit script, agreement, invoice, one-pager |
| `marketing/outreach/` | Email templates + playbook |
| `delivery/` | Client onboarding + delivery |
| `tools/LEAD-TRACKER.csv` | Pipeline |
| `apps/afterline/` | SMS API + admin (local) |

**Doing it right = daily outbound + honest audits + measured pilots.**
