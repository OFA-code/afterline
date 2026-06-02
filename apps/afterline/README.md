# Afterline API (v0.1)

Missed-call rescue, review SMS, and event logging for home-service clients.

## Quick start

```powershell
cd C:\Users\Trave\Projects\ai-business\apps\afterline
npm install
npm run setup
# Edit .env — Twilio keys from https://console.twilio.com
npm run dev
```

Open **http://localhost:3847/admin.html**

## Twilio webhooks (production)

When deployed (Railway, Render, Fly.io, or ngrok for testing):

| Event | URL |
|-------|-----|
| Incoming SMS | `POST https://YOUR_HOST/api/twilio/sms-inbound` |
| Voice status callback | `POST https://YOUR_HOST/api/twilio/voice-status` |

Set status callback on your Twilio number for `no-answer`, `busy`, `failed`.

## API

| Method | Path | Body |
|--------|------|------|
| GET | `/api/health` | — |
| GET | `/api/stats?clientId=demo` | Header `x-admin-secret` if set |
| POST | `/api/missed-call` | `{ "phone": "+1...", "name": "Jane", "clientId": "demo" }` |
| POST | `/api/job-complete` | `{ "phone": "+1...", "review_link": "https://..." }` |

Without Twilio keys, SMS is **simulated** and logged — safe for local testing.

## Multi-client

Edit `data/clients.json` — one key per client. Pass `clientId` on API calls.

Templates: `data/templates.json` — use `{{name}}`, `{{company}}`, `{{booking_link}}`, etc.

## Deploy

Recommended: **Railway** or **Render** (always-on for webhooks). Set env vars from `.env.example`.

Do not commit `.env` or `data/events.json` with real customer data.
