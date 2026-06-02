# Client ready checklist — before you take $497

Use this **before** sending the invoice. Prevents "service not fulfilled" complaints.

## You must be able to do ALL of these

| # | Capability | How to verify |
|---|------------|---------------|
| 1 | Receive booking leads | Submit test on https://ofa-code.github.io/afterline/book.html → lands in Microsoft inbox |
| 2 | Send SMS (or simulate with plan) | Twilio keys in `.env` OR documented Make.com flow ready |
| 3 | Missed-call trigger defined | Written in onboarding doc: how *their* missed call fires a text |
| 4 | Templates approved in writing | Client signed off on exact SMS text (pilot agreement + template doc) |
| 5 | Weekly report | You can send a 5-bullet Sunday email from their sheet/logs |
| 6 | SLA you can hit | 90% of missed-call texts within 90 sec **during their business hours** |

## Client must provide ALL of these before go-live

| # | Item | Why |
|---|------|-----|
| 1 | Business hours (timezone) | SLA only applies during stated hours |
| 2 | SMS opt-in / TCPA acknowledgment | They remain business of record |
| 3 | Call flow | Forward missed calls to Twilio OR daily export of missed numbers for v1 manual |
| 4 | Google review link | For post-job messages |
| 5 | Payment received + agreement signed | No work until paid |

## v1 delivery (what actually runs)

```
Missed call → (Twilio or manual trigger) → Afterline API → SMS template → log in admin
Job complete → you or client marks row → review SMS
Sunday → you send digest email from logs/sheet
```

**Partial automation is OK for pilot** if you document it and hit SLAs. Clients pay for **follow-through and reporting**, not a fancy dashboard on day one.

## If you cannot check every box

- **Do not sell yet** — finish Twilio + one test client (friend's business or your own number)
- Or **narrow scope** in writing: "Pilot = missed-call only" (no estimates until month 2)

## When something breaks

1. Fix within 24 hours
2. If SLA missed 7 days in a row (your fault) → next month waived per agreement
3. Never argue — show logs from admin + sheet

This checklist is how you sleep at night and keep clients happy.
