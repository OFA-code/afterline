import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const bundledDataDir = path.join(__dirname, '..', 'data');
const dataDir = process.env.VERCEL
  ? path.join('/tmp', 'afterline-data')
  : bundledDataDir;

function ensureDataDir() {
  if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
    for (const name of ['clients.json', 'templates.json', 'events.json', 'leads.json']) {
      const src = path.join(bundledDataDir, name);
      const dest = path.join(dataDir, name);
      if (fs.existsSync(src) && !fs.existsSync(dest)) {
        fs.copyFileSync(src, dest);
      }
    }
  }
}

function dataPath(name) {
  ensureDataDir();
  return path.join(dataDir, name);
}

function readJson(file, fallback) {
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch {
    return fallback;
  }
}

function writeJson(file, data) {
  try {
    fs.writeFileSync(file, JSON.stringify(data, null, 2));
  } catch (e) {
    if (!process.env.VERCEL) throw e;
    console.error('writeJson skipped on Vercel', file, e.message);
  }
}

export function getClients() {
  return readJson(dataPath('clients.json'), {});
}

export function getTemplates() {
  return readJson(dataPath('templates.json'), {});
}

export function logEvent(event) {
  const eventsFile = dataPath('events.json');
  const events = readJson(eventsFile, []);
  events.push({
    ...event,
    id: `evt_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`,
    at: new Date().toISOString(),
  });
  writeJson(eventsFile, events.slice(-5000));
}

export function getEvents(clientId, limit = 100) {
  const events = readJson(dataPath('events.json'), []);
  return events
    .filter((e) => !clientId || e.clientId === clientId)
    .slice(-limit)
    .reverse();
}

export function getStats(clientId) {
  const events = getEvents(clientId, 500);
  const sent = events.filter((e) => e.type === 'sms_sent').length;
  const missed = events.filter((e) => e.type === 'missed_call').length;
  const replies = events.filter((e) => e.type === 'sms_reply').length;
  return { sent, missed, replies, total: events.length, leads: getLeads().length };
}

export function addLead(lead) {
  const leadsFile = dataPath('leads.json');
  const leads = readJson(leadsFile, []);
  const row = {
    id: `lead_${Date.now()}`,
    at: new Date().toISOString(),
    status: 'new',
    ...lead,
  };
  leads.push(row);
  writeJson(leadsFile, leads);
  logEvent({ type: 'lead', clientId: 'demo', ...row });
  return row;
}

export function getLeads(limit = 50) {
  return readJson(dataPath('leads.json'), []).slice(-limit).reverse();
}
