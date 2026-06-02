# Set up Afterline in one sitting

Your business lives at `C:\Users\Trave\Projects\ai-business`.  
Goal path: **$30k/mo** = ~20 clients × $1,497 (see `GOALS-30K.md`).  
This week: **2 audit calls → 1 pilot ($497)**.

---

## Today (60–90 minutes)

### 1. Replace placeholders

Search `ai-business` for:

- `YOUR_CALENDLY` → your Calendly link (free at calendly.com)
- `YOUR_EMAIL` → business email

Files: `marketing/landing/*.html`, `apps/afterline/data/clients.json`

### 2. Landing page live

```powershell
cd C:\Users\Trave\Projects\ai-business\marketing\landing
npx --yes serve -l 3000
```

Or deploy free on Vercel:

```powershell
cd C:\Users\Trave\Projects\ai-business\marketing\landing
npx --yes vercel --yes
```

Point a domain later (optional).

### 3. Afterline API

```powershell
cd C:\Users\Trave\Projects\ai-business\apps\afterline
npm install
npm run setup
notepad .env
npm run dev
```

Add Twilio when ready ($15 credit on signup). Until then, admin shows **simulated** sends.

### 4. First outreach (10 messages)

Open `marketing/outreach/cold-email.md` — send 10 personalized emails to local HVAC/plumbing owners.  
Book audits on Calendly.

### 5. Run the plan

Follow `30-DAY-PLAN.md` week 1 checklist daily.

---

## What’s already built

| Asset | Location |
|-------|----------|
| Offer, pricing, ethics | `offer/` |
| Sales scripts | `sales/` |
| Landing + legal | `marketing/landing/` |
| Delivery playbook | `delivery/` |
| SMS API + admin | `apps/afterline/` |
| gstack skills | `~/.cursor/skills/` |

---

## Cursor commands that help

In any chat in `ai-business`:

- `/office-hours` — plan the week
- `/ship` — ship landing or app changes
- `/qa` — test before you demo to a client

---

## Honest math (not fighting you)

- **$30k/mo** is real and achievable with this model — typically **12–18 months** of consistent sales + delivery.
- **This month** win = pilots + proof, not $30k on day one.
- One **$497 pilot** + one **$997/mo** convert = you’re in business.

You have skills + AI. The stack is built. The lever now is **conversations with owners who already lose money on missed calls**.
