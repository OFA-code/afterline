import twilio from 'twilio';
import { getClients, getTemplates, logEvent } from './store.js';

function render(template, vars) {
  return template.replace(/\{\{(\w+)\}\}/g, (_, key) => vars[key] ?? '');
}

export async function sendTemplated(clientId, templateKey, to, extra = {}) {
  const sid = process.env.TWILIO_ACCOUNT_SID;
  const token = process.env.TWILIO_AUTH_TOKEN;
  const from = process.env.TWILIO_FROM_NUMBER;

  if (!sid || !token || !from) {
    logEvent({
      clientId,
      type: 'sms_skipped',
      to,
      reason: 'Twilio not configured',
      templateKey,
    });
    return { ok: false, simulated: true, body: '[SMS simulated — add Twilio keys to .env]' };
  }

  const clients = getClients();
  const client = clients[clientId] || clients[process.env.DEFAULT_CLIENT_ID];
  const templates = getTemplates();
  const raw = templates[templateKey];
  if (!raw) throw new Error(`Unknown template: ${templateKey}`);

  const body = render(raw, {
    name: extra.name || 'there',
    company: client?.name || 'our team',
    trade: client?.trade || 'service',
    booking_link: client?.bookingLink || 'https://example.com',
    review_link: extra.review_link || 'https://g.page/r/PLACEHOLDER/review',
    ...extra,
  });

  const tw = twilio(sid, token);
  const msg = await tw.messages.create({ from, to, body });

  logEvent({ clientId, type: 'sms_sent', to, templateKey, sid: msg.sid });
  return { ok: true, sid: msg.sid, body };
}

export async function handleMissedCall(clientId, callerPhone, callerName = '') {
  logEvent({ clientId, type: 'missed_call', phone: callerPhone, name: callerName });

  await new Promise((r) => setTimeout(r, 30000));

  return sendTemplated(clientId, 'missed_call_1', callerPhone, { name: callerName || 'there' });
}
