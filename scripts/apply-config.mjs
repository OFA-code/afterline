import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const cfg = JSON.parse(fs.readFileSync(path.join(root, 'config', 'business.json'), 'utf8'));

const landingUrl = cfg.landingUrl || `https://${cfg.githubUser}.github.io/${cfg.repoName}/`;
const bookingUrl = cfg.bookingUrl || `${landingUrl}${cfg.bookingPath.replace(/^\//, '')}`;
const cityLabel = cfg.city ? `${cfg.city}, ${cfg.state || ''}`.trim().replace(/,\s*$/, '') : 'your area';
const regionLabel = cfg.region || cityLabel;

const replacements = {
  YOUR_EMAIL: cfg.businessEmail,
  YOUR_CC_EMAIL: cfg.personalEmail || cfg.businessEmail,
  YOUR_CALENDLY: bookingUrl,
  YOUR_NAME: cfg.operatorName,
  YOUR_LEGAL_ENTITY: cfg.legalEntity || cfg.brand,
  '{{CALENDLY}}': bookingUrl,
  '{{LANDING_URL}}': landingUrl,
  '{{YourName}}': cfg.operatorName,
  '{{City}}': cityLabel,
  '{{Region}}': regionLabel,
  '{{trade}}': cfg.primaryTrade,
  'Trave@users.noreply.github.com': cfg.businessEmail,
};

const files = [
  'marketing/landing/index.html',
  'marketing/landing/terms.html',
  'marketing/landing/privacy.html',
  'marketing/landing/book.html',
  'apps/afterline/data/clients.json',
  'marketing/outreach/cold-email.md',
  'marketing/outreach/cold-dm-linkedin.md',
  'README.md',
  'ONE-THING-LEFT.md',
  'sales/pilot-agreement-template.md',
];

function patchFile(rel) {
  const file = path.join(root, rel);
  if (!fs.existsSync(file)) return;
  let text = fs.readFileSync(file, 'utf8');
  for (const [from, to] of Object.entries(replacements)) {
    text = text.split(from).join(to);
  }
  fs.writeFileSync(file, text);
}

files.forEach(patchFile);

const bookPath = path.join(root, 'marketing/landing/book.html');
if (fs.existsSync(bookPath)) {
  let book = fs.readFileSync(bookPath, 'utf8');
  book = book.replace(/window\.AFTERLINE_BOOK_EMAIL = '[^']*';/, `window.AFTERLINE_BOOK_EMAIL = '${cfg.businessEmail}';`);
  book = book.replace(/window\.AFTERLINE_CC_EMAIL = '[^']*';/, `window.AFTERLINE_CC_EMAIL = '${cfg.personalEmail || cfg.businessEmail}';`);
  fs.writeFileSync(bookPath, book);
}

const clients = JSON.parse(fs.readFileSync(path.join(root, 'apps/afterline/data/clients.json'), 'utf8'));
clients.demo.name = cfg.city ? `${cfg.city} ${cfg.primaryTrade} (demo)` : `Demo ${cfg.primaryTrade}`;
clients.demo.trade = cfg.primaryTrade;
clients.demo.bookingLink = bookingUrl;
clients.demo.ownerEmail = cfg.businessEmail;
fs.writeFileSync(path.join(root, 'apps/afterline/data/clients.json'), JSON.stringify(clients, null, 2) + '\n');

const landingDir = path.join(root, 'marketing/landing');
const docsDir = path.join(root, 'docs');
if (fs.existsSync(docsDir) && fs.existsSync(landingDir)) {
  for (const name of fs.readdirSync(landingDir)) {
    if (name.endsWith('.html') || name.endsWith('.css')) {
      fs.copyFileSync(path.join(landingDir, name), path.join(docsDir, name));
    }
  }
}

console.log('Config applied.');
console.log('  Brand:   ', cfg.brand, 'by', cfg.legalEntity);
console.log('  Landing: ', landingUrl);
console.log('  Booking: ', bookingUrl);
console.log('  Email:   ', cfg.businessEmail);
console.log('  CC:      ', cfg.personalEmail || '(none)');
