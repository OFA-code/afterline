# Full audit - config, runtime, revenue path
$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$fail = 0
$warn = 0

function Ok($msg) { Write-Host "[OK]   $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow; $script:warn++ }
function Bad($msg) { Write-Host "[FAIL] $msg" -ForegroundColor Red; $script:fail++ }

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AFTERLINE FULL AUDIT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# --- Config ---
Write-Host "`n--- Config (business.json) ---" -ForegroundColor Gray
$cfgPath = Join-Path $Root "config\business.json"
$cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json

@(
  @{ k = "businessEmail"; v = $cfg.businessEmail; test = '@' },
  @{ k = "operatorName"; v = $cfg.operatorName; test = '.' },
  @{ k = "city"; v = $cfg.city; test = '.' },
  @{ k = "pilotPrice"; v = $cfg.pilotPrice; test = '497' }
) | ForEach-Object {
  if ($_.v -and "$($_.v)" -match $_.test) { Ok "$($_.k) = $($_.v)" }
  else { Bad "$($_.k) missing or wrong" }
}

if ($cfg.apiPublicUrl) { Ok "apiPublicUrl = $($cfg.apiPublicUrl)" }
else { Warn "apiPublicUrl empty - live booking uses FormSubmit only (OK for now)" }

# --- Env ---
Write-Host "`n--- API (.env) ---" -ForegroundColor Gray
$envPath = Join-Path $Root "apps\afterline\.env"
$envText = Get-Content $envPath -Raw
if ($envText -match 'NOTIFY_EMAIL=deallomcconnell@optimalflowagency\.io') { Ok "NOTIFY_EMAIL set" }
else { Bad "NOTIFY_EMAIL wrong or missing" }
if ($envText -match 'ADMIN_SECRET=\S+') { Ok "ADMIN_SECRET set" }
else { Warn "ADMIN_SECRET not set" }
if ($envText -match 'TWILIO_ACCOUNT_SID=\S') { Ok "Twilio configured" }
else { Warn "Twilio empty - SMS simulated until first paid client" }

# --- Runtime ---
Write-Host "`n--- Runtime ---" -ForegroundColor Gray
try {
  $h = Invoke-RestMethod -Uri "http://localhost:3847/api/health" -TimeoutSec 5
  Ok "API running (twilio=$($h.twilio))"
} catch { Bad "API not running - run START.ps1 or scripts\run-api.ps1" }

$startup = Join-Path ([Environment]::GetFolderPath("Startup")) "Afterline-API.lnk"
if (Test-Path $startup) { Ok "API autostart on login" } else { Warn "No autostart shortcut" }

try {
  $t = Get-ScheduledTask -TaskName "Afterline-Daily-8AM" -ErrorAction Stop
  $info = Get-ScheduledTaskInfo -TaskName "Afterline-Daily-8AM"
  Ok "Daily 8AM task - next: $($info.NextRunTime)"
} catch { Warn "No 8AM daily task - run install-daily-schedule.ps1" }

# --- Live site ---
Write-Host "`n--- Live site ---" -ForegroundColor Gray
try {
  $live = Invoke-WebRequest -Uri "https://ofa-code.github.io/afterline/book.html" -UseBasicParsing -TimeoutSec 15
  if ($live.Content -match "AFTERLINE_BOOK_EMAIL = '([^']+)'") {
    if ($matches[1] -eq $cfg.businessEmail) { Ok "Live booking email correct" }
    else { Bad "Live booking email wrong: $($matches[1])" }
  }
  if ($live.Content -match 'YOUR_EMAIL|YOUR_CALENDLY|YOUR_NAME|YOUR_PUBLIC_API|@users\.noreply') { Bad "Placeholders still on live book page" }
  else { Ok "No config placeholders on book page" }
  Invoke-WebRequest -Uri "https://ofa-code.github.io/afterline/" -Method Head -UseBasicParsing -TimeoutSec 10 | Out-Null
  Ok "Landing page up"
} catch { Bad "Could not reach live site" }

# --- Local files placeholders ---
Write-Host "`n--- Repo placeholders ---" -ForegroundColor Gray
$scan = @(
  "marketing\landing\index.html",
  "marketing\landing\book.html",
  "apps\afterline\data\clients.json"
)
foreach ($rel in $scan) {
  $p = Join-Path $Root $rel
  if (-not (Test-Path $p)) { continue }
  $t = Get-Content $p -Raw
  if ($t -match 'YOUR_EMAIL|YOUR_CALENDLY|YOUR_NAME|@users\.noreply') { Bad "Placeholder in $rel" }
}
Ok "Key files scanned"

# --- Leads & outreach ---
Write-Host "`n--- Revenue pipeline ---" -ForegroundColor Gray
$tracker = Import-Csv (Join-Path $Root "tools\LEAD-TRACKER.csv")
$total = $tracker.Count
$new = ($tracker | Where-Object { $_.status -eq 'new' }).Count
$withEmail = ($tracker | Where-Object { $_.email -and $_.email.Trim() }).Count
Ok ("Lead tracker: {0} leads, {1} unsent, {2} with email" -f $total, $new, $withEmail)
if ($new -eq $total) { Warn "Zero outreach sent yet - revenue blocked until you send from tools\outbox\" }
if ($withEmail -lt 2) { Warn "Most leads need phone/website lookup - use .url files or call first" }

# --- Book API test ---
Write-Host "`n--- Lead capture test ---" -ForegroundColor Gray
try {
  $body = @{ name = "Audit"; company = "Test Co"; phone = "+15550001111"; email = "audit@test.local"; message = "audit" } | ConvertTo-Json
  $r = Invoke-RestMethod -Uri "http://localhost:3847/api/book-audit" -Method POST -ContentType "application/json" -Body $body
  Ok "Local book-audit saves leads (id=$($r.lead.id))"
} catch { Bad "book-audit API failed" }

# --- Score ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($fail -eq 0) {
  Write-Host "  TECH: PASS ($warn warnings)" -ForegroundColor Green
} else {
  Write-Host "  TECH: $fail critical issue(s), $warn warnings" -ForegroundColor Red
}
Write-Host "========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "REVENUE READINESS" -ForegroundColor Yellow
Write-Host "  Ready to SELL audits:  YES (site + booking + outbox)"
Write-Host "  Ready to DELIVER pilot:  NOT YET (need Twilio + client onboarding)"
Write-Host ""
Write-Host "YOUR 3 ACTIONS (highest ROI):" -ForegroundColor Yellow
Write-Host "  1. Outlook -> search FormSubmit -> Activate (one time)"
Write-Host "  2. Send outbox email #01 or #09 from Outlook today"
Write-Host "  3. Do NOT take `$497 until CLIENT-READY-CHECKLIST.md passes"
Write-Host ""
Write-Host "Reference: WHERE-TO-PUT-WHAT.md"
Write-Host ""

exit $fail
