# Delivery playbook (v1 — you can be 80% behind the scenes)

## Stack (start simple, upgrade later)

| Layer | v1 (week 1) | v2 (after 3 clients) |
|-------|-------------|----------------------|
| SMS | Twilio | Twilio + dedicated number per client |
| Automation | Make.com or n8n | Same + webhooks |
| Email digest | Gmail + AI summary | Scheduled script |
| CRM | Google Sheet | Jobber/ServiceTitan integration |
| AI drafts | Claude/Cursor with locked templates | API + approval queue |

## Day 0–2: Onboarding

See [client-onboarding.md](client-onboarding.md).

## Missed-call flow

1. Trigger: missed call from Twilio/voicemail forward OR manual Zap from phone system
2. Wait 30 sec (avoid double-text if they call back)
3. Send template `MISSED_CALL_1` with {name}, {company}, {booking_link}
4. If no reply in 4h → `MISSED_CALL_2`
5. Log in client sheet

**SLA:** 90% within 90 seconds during business hours.

## Review flow

1. Trigger: client marks job complete (form or sheet row)
2. Wait 2 hours
3. Send `REVIEW_1` with Google review link
4. Day 3: one reminder if no click
5. Negative reply keyword → alert owner email, no auto reply

## Estimate follow-up

1. Import open estimates weekly (CSV from client)
2. Day 1/3/7/14 messages from approved sequence
3. Stop on reply or "closed"

## Weekly digest (AI-assisted)

Prompt template:

```
Summarize for a busy HVAC owner in 5 bullets:
- Texts sent / replies received
- Reviews gained
- Estimates nudged / replies
- One win, one action item
Data: [paste sheet export]
Tone: direct, no jargon
```

Send Sunday 6pm local.

## Quality control (10 min/client/week)

- Read 5 random outbound messages
- Check SLA dashboard
- One tweak to template if needed

## When to escalate to yourself

- Angry customer reply
- Legal/compliance question
- Custom integration request → quote separately
