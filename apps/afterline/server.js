import 'dotenv/config';
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import { addLead, getClients, getEvents, getLeads, getStats, logEvent } from './lib/store.js';
import { handleMissedCall, sendTemplated } from './lib/sms.js';
import { notifyNewLead } from './lib/notify.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 3847;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

const allowedOrigins = [
  'http://localhost:3847',
  'http://127.0.0.1:3847',
  'http://localhost:3000',
  /^https:\/\/ofa-code\.github\.io$/,
  /^https:\/\/.*\.onrender\.com$/,
  /^https:\/\/.*\.vercel\.app$/,
];
app.use((req, res, next) => {
  const origin = req.headers.origin;
  if (origin && allowedOrigins.some((o) => (o instanceof RegExp ? o.test(origin) : o === origin))) {
    res.setHeader('Access-Control-Allow-Origin', origin);
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, x-admin-secret');
  }
  if (req.method === 'OPTIONS') return res.sendStatus(204);
  next();
});

function adminAuth(req, res, next) {
  const secret = process.env.ADMIN_SECRET;
  if (!secret) return next();
  const key = req.headers['x-admin-secret'] || req.query.key;
  if (key !== secret) return res.status(401).json({ error: 'unauthorized' });
  next();
}

app.get('/api/health', (_, res) => {
  res.json({ ok: true, service: 'afterline', twilio: Boolean(process.env.TWILIO_ACCOUNT_SID) });
});

app.get('/api/stats', adminAuth, (req, res) => {
  const clientId = req.query.clientId || process.env.DEFAULT_CLIENT_ID || 'demo';
  res.json({ clientId, ...getStats(clientId), clients: Object.keys(getClients()) });
});

app.get('/api/events', adminAuth, (req, res) => {
  const clientId = req.query.clientId || process.env.DEFAULT_CLIENT_ID;
  res.json({ events: getEvents(clientId, Number(req.query.limit) || 50) });
});

app.post('/api/book-audit', (req, res) => {
  try {
    const { name, company, phone, email, message } = req.body || {};
    if (!name || !company || !phone) {
      return res.status(400).json({ error: 'name, company, phone required' });
    }
    const lead = addLead({ name, company, phone, email: email || '', message: message || '' });
    notifyNewLead(lead).catch((e) => console.error('notify', e));
    res.json({ ok: true, lead });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/api/leads', adminAuth, (req, res) => {
  res.json({ leads: getLeads(Number(req.query.limit) || 50) });
});

app.post('/api/missed-call', adminAuth, async (req, res) => {
  try {
    const { phone, name, clientId } = req.body;
    if (!phone) return res.status(400).json({ error: 'phone required' });
    const cid = clientId || process.env.DEFAULT_CLIENT_ID || 'demo';
    const result = await handleMissedCall(cid, phone, name || '');
    res.json({ ok: true, result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/job-complete', adminAuth, async (req, res) => {
  try {
    const { phone, review_link, clientId } = req.body;
    if (!phone) return res.status(400).json({ error: 'phone required' });
    const cid = clientId || process.env.DEFAULT_CLIENT_ID || 'demo';
    const result = await sendTemplated(cid, 'review_1', phone, { review_link });
    res.json({ ok: true, result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post('/api/twilio/sms-inbound', (req, res) => {
  const from = req.body.From;
  const body = req.body.Body;
  logEvent({
    clientId: process.env.DEFAULT_CLIENT_ID || 'demo',
    type: 'sms_reply',
    phone: from,
    body,
  });
  res.type('text/xml').send('<Response></Response>');
});

app.post('/api/twilio/voice-status', async (req, res) => {
  const status = req.body.CallStatus;
  const from = req.body.From;
  if (['no-answer', 'busy', 'failed', 'canceled'].includes(status) && from) {
    const cid = process.env.DEFAULT_CLIENT_ID || 'demo';
    handleMissedCall(cid, from).catch((e) => console.error('missed-call', e));
  }
  res.type('text/xml').send('<Response></Response>');
});

app.listen(PORT, () => {
  console.log(`Afterline API http://localhost:${PORT}`);
  console.log(`Admin dashboard http://localhost:${PORT}/admin.html`);
});
