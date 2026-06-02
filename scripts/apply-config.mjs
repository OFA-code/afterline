import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const cfg = JSON.parse(fs.readFileSync(path.join(root, 'config', 'business.json'), 'utf8'));

const landingUrl = `https://${cfg.githubUser}.github.io/${cfg.repoName}/`;
const bookingUrl = `${landingUrl}${cfg.bookingPath.replace(/^\//, '')}`;
const mailto = `mailto:${cfg.businessEmail}?subject=${encodeURIComponent('Afterline — Revenue Leak Audit')}`;

const replacements = {
  YOUR_EMAIL: cfg.businessEmail,
  YOUR_CALENDLY: bookingUrl,
  YOUR_NAME: cfg.operatorName,
  '{{CALENDLY}}': bookingUrl,
  '{{LANDING_URL}}': landingUrl,
  '{{YourName}}': cfg.operatorName,
  '{{City}}': cfg.city,
  '{{trade}}': cfg.primaryTrade,
};

function patchFile(rel) {
  const file = path.join(root, rel);
  if (!fs.existsSync(file)) return;
  let text = fs.readFileSync(file, 'utf8');
  let changed = false;
  for (const [from, to] of Object.entries(replacements)) {
    if (text.includes(from)) {
      text = text.split(from).join(to);
      changed = true;
    }
  }
  if (changed) fs.writeFileSync(file, text);
}

const files = [
  'marketing/landing/index.html',
  'marketing/landing/terms.html',
  'marketing/landing/privacy.html',
  'marketing/landing/book.html',
  'apps/afterline/data/clients.json',
  'marketing/outreach/cold-email.md',
  'README.md',
];

files.forEach(patchFile);

const bookPath = path.join(root, 'marketing/landing/book.html');
if (fs.existsSync(bookPath)) {
  let book = fs.readFileSync(bookPath, 'utf8');
  const api = cfg.apiUrl || 'http://localhost:3847';
  book = book.replace(
    /const API = window\.AFTERLINE_API \|\|[^;]+;/,
    `const API = window.AFTERLINE_API || '${api}';`
  );
  book = book.replace(/YOUR_EMAIL/g, cfg.businessEmail);
  book = book.replace(
    /window\.AFTERLINE_BOOK_EMAIL = '[^']*';?/,
    `window.AFTERLINE_BOOK_EMAIL = '${cfg.businessEmail}';`
  );
  if (!book.includes('AFTERLINE_BOOK_EMAIL')) {
    book = book.replace(
      '<script>',
      `<script>\n    window.AFTERLINE_BOOK_EMAIL = '${cfg.businessEmail}';\n    window.AFTERLINE_API = '${api}';`
    );
  }
  fs.writeFileSync(bookPath, book);
}

const clients = JSON.parse(fs.readFileSync(path.join(root, 'apps/afterline/data/clients.json'), 'utf8'));
clients.demo.name = `${cfg.city} ${cfg.primaryTrade} (demo)`;
clients.demo.trade = cfg.primaryTrade;
clients.demo.bookingLink = bookingUrl;
clients.demo.ownerEmail = cfg.businessEmail;
fs.writeFileSync(path.join(root, 'apps/afterline/data/clients.json'), JSON.stringify(clients, null, 2) + '\n');

console.log('Config applied.');
console.log('  Landing:', landingUrl);
console.log('  Booking:', bookingUrl);
console.log('  Email:  ', cfg.businessEmail);
