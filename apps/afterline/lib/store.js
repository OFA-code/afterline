import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dataDir = path.join(__dirname, '..', 'data');
const eventsFile = path.join(dataDir, 'events.json');
const leadsFile = path.join(dataDir, 'leads.json');

function readJson(file, fallback) {
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch {
    return fallback;
  }
}

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

export function getClients() {
  return readJson(path.join(dataDir, 'clients.json'), {});
}

export function getTemplates() {
  return readJson(path.join(dataDir, 'templates.json'), {});
}

export function logEvent(event) {
  const events = readJson(eventsFile, []);
  events.push({
    ...event,
    id: `evt_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`,
    at: new Date().toISOString(),
  });
  writeJson(eventsFile, events.slice(-5000));
}

export function getEvents(clientId, limit = 100) {
  const events = readJson(eventsFile, []);
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
  return readJson(leadsFile, []).slice(-limit).reverse();
}
