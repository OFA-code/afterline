# Setup status — Afterline

**You are past the placeholder phase.** Everything flows from one file.

## Single source of truth

Edit **`config/business.json`**, then run:

```powershell
node scripts\apply-config.mjs
```

See **`WHERE-TO-PUT-WHAT.md`** for every field.

## What's already set

| Item | Value |
|------|-------|
| Email | deallomcconnell@optimalflowagency.io |
| CC | deallomcconnell@gmail.com |
| Booking | https://ofa-code.github.io/afterline/book.html |
| Market | Hardy, AR + remote US |
| Pricing | $497 pilot / $997 / $1,497 |

## Run audit anytime

```powershell
powershell -ExecutionPolicy Bypass -File scripts\audit-all.ps1
```

## This week's revenue goal

**2 audit calls → 1 pilot ($497)**

1. Activate FormSubmit in Outlook (one time)
2. Send `tools/outbox/01-richards-hardy.txt` or `09-serveway.url`
3. Log sends in `tools/LEAD-TRACKER.csv`

## Daily

Double-click **`START.ps1`** (or wait for 8 AM auto-start)
