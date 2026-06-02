# Operating system — do it right

**One folder. One rhythm. One offer.**

Afterline is the **field-service entry product** of [Optimal Flow Agency](https://www.optimalflowagency.io). Same ethics, same KPI discipline, simpler scope for HVAC/plumbing/roofing shops.

---

## Daily rhythm (60–90 min until first pilot closes)

| Block | Time | Action |
|-------|------|--------|
| **Morning** | 15 min | Open `operations/DAILY-RHYTHM.md` checklist |
| **Outbound** | 30 min | 10 touches (email or LinkedIn) — `marketing/outreach/PLAYBOOK.md` |
| **Pipeline** | 10 min | Update `tools/LEAD-TRACKER.csv` |
| **Delivery** | 15 min | Only if client signed — `delivery/PLAYBOOK.md` |
| **Admin** | 5 min | Check inbox + http://localhost:3847/admin.html (API via `START.ps1`) |

Run: `powershell -File scripts/daily-start.ps1`

---

## What you sell (memorize this)

> "We recover revenue you already paid for — missed-call text-back in under 60 seconds, estimate follow-up, and review requests. $497 pilot, 30 days, measured week 1 vs week 4. Month-to-month after. We're not an ad agency."

**Not a fit:** under 10 leads/month, won't approve templates, wants ads only.

**Great fit:** 3–20 employees, busy phones, open estimates piling up, strong Google presence but slow follow-up.

---

## Links (only these)

| Asset | URL |
|-------|-----|
| Afterline landing | https://ofa-code.github.io/afterline/ |
| Book audit | https://ofa-code.github.io/afterline/book.html |
| Parent brand (ILRS / high-ticket) | https://www.optimalflowagency.io |
| Repo | https://github.com/OFA-code/afterline |

---

## Sales path (no shortcuts)

```
Outreach → 15-min audit (AUDIT-CALL.md) → Verbal yes → Pilot agreement + invoice → Onboard → Deliver → Report → Convert to $997/mo
```

Files:

- Script: `sales/AUDIT-CALL.md`
- Agreement: `sales/pilot-agreement-template.md`
- Invoice: `sales/PILOT-INVOICE.md`
- Objections: `sales/OBJECTIONS.md`
- One-pager: `sales/audit-one-pager.html` (print or PDF)

---

## Week 1 targets (non-negotiable)

- [ ] Set your **city** in `config/business.json` → run `node scripts/apply-config.mjs` → push
- [ ] Activate **FormSubmit** (click link in agency inbox once)
- [ ] Build **50 leads** in `tools/LEAD-TRACKER.csv` (Google Maps method in outreach playbook)
- [ ] Send **50 outbound touches** (10/day × 5 days)
- [ ] Book **3 audit calls**
- [ ] Close **1 pilot @ $497**

---

## Pricing ladder (stay consistent)

| Tier | Price | Who |
|------|-------|-----|
| Pilot | $497 / 30 days | Prove ROI on one shop |
| Starter | $997 / mo | One location, standard volume |
| Growth | $1,497 / mo | High volume + estimate sequences |
| ILRS / enterprise | $2k–$25k | Setter/closer teams — [optimalflowagency.io](https://www.optimalflowagency.io) |

Do not discount the pilot without removing scope. Do not promise ads or guaranteed job counts.

---

## Delivery standard

1. Templates approved in writing (client-onboarding.md)
2. Missed-call live within 5 business days
3. Sunday report every week during pilot
4. Week 1 vs week 4 comparison before renewal conversation

---

## Config is source of truth

Edit `config/business.json` → `node scripts/apply-config.mjs` → copies to landing, docs, outreach, API.

Never hand-edit `docs/` — it is generated from `marketing/landing/`.

---

## When stuck

1. `/office-hours` in Cursor (gstack) — plan the week
2. Re-read `offer/ETHICS.md` — if it feels wrong, don't sell it
3. Disqualify fast — reputation compounds

**Doing it right = consistent outbound + honest audits + measured pilots. Not more tools.**
