# Outreach playbook — do it right

## Step 1: Pick your city (once)

Edit `config/business.json`:

```json
"city": "Chicago",
"state": "IL"
```

Run: `node scripts/apply-config.mjs` then commit and push.

## Step 2: Build your list (Google Maps)

1. Open Google Maps → search `HVAC near [your city]`
2. Open each listing with **4+ stars** and **50+ reviews**
3. Copy to `tools/LEAD-TRACKER.csv`:
   - company, owner first name (from reviews or website), trade, email, phone, notes
4. Find email: website contact page, or `{owner}@{companydomain}.com`
5. Goal: **50 rows** before you send batch 1

**Do not** claim you "drove by" unless true. Use real observations: review count, hiring post, seasonal Google post.

## Step 3: Send sequence

| Day | Template |
|-----|----------|
| 0 | `marketing/outreach/emails/01-leak.md` |
| 4 | `marketing/outreach/emails/02-bump.md` |
| 8 | `marketing/outreach/emails/03-breakup.md` |

Or double-click `.url` files in `marketing/outreach/ready/` for mailto shortcuts.

**Rules:**

- Max 120 words
- One CTA: book link
- 10 sends per day minimum
- Track in LEAD-TRACKER.csv

## Step 4: LinkedIn (optional, 10/day)

Use `marketing/outreach/cold-dm-linkedin.md` — connection request + one message after accept.

## Step 5: When they reply

1. Book audit within 48 hours
2. Run `sales/AUDIT-CALL.md`
3. If yes → `sales/pilot-agreement-template.md` + `sales/PILOT-INVOICE.md`

## Booking link (always use this)

https://ofa-code.github.io/afterline/book.html

## Signature

```
Deallo McConnell
Afterline · Optimal Flow Agency
deallomcconnell@optimalflowagency.io
Book a 15-min audit: https://ofa-code.github.io/afterline/book.html
```
