const BUSINESS_EMAIL = process.env.NOTIFY_EMAIL || process.env.BUSINESS_EMAIL || 'deallomcconnell@optimalflowagency.io';
const CC_EMAIL = process.env.NOTIFY_CC || process.env.PERSONAL_EMAIL || '';

export async function notifyNewLead(lead) {
  const payload = {
    name: lead.name,
    company: lead.company,
    phone: lead.phone,
    email: lead.email || '',
    message: lead.message || '',
    _subject: `Afterline audit — ${lead.company}`,
    _template: 'table',
    _captcha: 'false',
  };
  if (CC_EMAIL) payload._cc = CC_EMAIL;

  try {
    const res = await fetch(`https://formsubmit.co/ajax/${encodeURIComponent(BUSINESS_EMAIL)}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body: JSON.stringify(payload),
    });
    return { ok: res.ok };
  } catch (e) {
    console.error('notify email failed', e.message);
    return { ok: false, error: e.message };
  }
}
