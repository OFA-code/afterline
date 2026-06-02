import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const envPath = path.join(root, '.env');
const eventsPath = path.join(root, 'data', 'events.json');

if (!fs.existsSync(envPath)) {
  fs.copyFileSync(path.join(root, '.env.example'), envPath);
  console.log('Created .env from .env.example — add Twilio credentials.');
}

if (!fs.existsSync(eventsPath)) {
  fs.writeFileSync(eventsPath, '[]\n');
  console.log('Created data/events.json');
}

console.log('\nNext steps:');
console.log('1. Edit apps/afterline/.env with Twilio SID, token, and FROM number');
console.log('2. npm install && npm run dev');
console.log('3. Open http://localhost:3847/admin.html');
console.log('4. Point Twilio webhooks to your public URL (ngrok or deploy)');
