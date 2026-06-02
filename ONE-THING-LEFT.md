# Only you can do these (accounts & money)

Everything else is built and automated. These need **your** login once:

| Step | Time | Link |
|------|------|------|
| **1. Business email** | 2 min | Edit `config\business.json` → set `businessEmail` to Gmail you check. Run `node scripts\apply-config.mjs` |
| **2. GitHub Pages** | 0 min | Run `START.ps1` — deploys automatically if `gh` is logged in |
| **3. Twilio (real SMS)** | 10 min | [console.twilio.com](https://console.twilio.com) → paste into `apps\afterline\.env` |
| **4. Send 10 emails** | 30 min | Open `marketing\outreach\ready\` → double-click `.url` files, fill company name, send |

**Booking link to share:** `https://OFA-code.github.io/afterline/book.html`

**Leads:** http://localhost:3847/admin.html (keep API running via START.ps1)
