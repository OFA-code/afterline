# Email setup — Microsoft is fine

You do **not** need Gmail for Afterline to work.

## Where mail goes

| Purpose | Address | Provider |
|---------|---------|----------|
| **Primary (use this)** | deallomcconnell@optimalflowagency.io | Microsoft / Outlook |
| **Optional backup copy** | deallomcconnell@gmail.com | Gmail — only if you want a CC |

**Booking form (FormSubmit)** delivers to **deallomcconnell@optimalflowagency.io**.  
Activate FormSubmit once in your **Microsoft inbox** (check spam for "FormSubmit" → click Activate).

**Outbound sales email** — send from Microsoft Outlook. That looks more professional than Gmail for Optimal Flow Agency anyway.

Gmail is only used today as an optional CC on booking submissions. If you prefer Microsoft only, leave `personalEmail` blank in `config/business.json` and run `node scripts/apply-config.mjs`.

## What you need working (your end)

- [ ] Microsoft inbox receives mail at deallomcconnell@optimalflowagency.io
- [ ] FormSubmit activated (one-time click in that inbox)
- [ ] You reply to audit requests within 1 business day
- [ ] Before first pilot: Twilio account + keys in `apps/afterline/.env` (for SMS delivery)

## What clients need (their end — you set up in onboarding)

- [ ] Business phone that can forward missed calls OR trigger webhooks (Twilio number works best)
- [ ] Approved SMS templates in writing (their tone)
- [ ] Google Business Profile access (for review links)
- [ ] One contact person for approvals
- [ ] List of open estimates (CSV) if estimate follow-up is included

**You do not visit their shop.** Everything is remote: Zoom/onboarding call, template approval, Twilio + their call forwarding.

## Honest rule

**Do not close a pilot until you can run the missed-call test end-to-end** (even simulated in admin).  
See `delivery/CLIENT-READY-CHECKLIST.md` before taking payment.
