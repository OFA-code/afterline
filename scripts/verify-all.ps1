# Health checks - run after setup
$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$fail = 0

Write-Host ""
Write-Host "=== Afterline verify ===" -ForegroundColor Cyan

try {
  $h = Invoke-RestMethod -Uri "http://localhost:3847/api/health" -TimeoutSec 5
  Write-Host "[OK] API running (twilio=$($h.twilio))" -ForegroundColor Green
} catch {
  Write-Host "[FAIL] API not running - run START.ps1" -ForegroundColor Red
  $fail++
}

try {
  Invoke-WebRequest -Uri "https://ofa-code.github.io/afterline/" -Method Head -TimeoutSec 10 -UseBasicParsing | Out-Null
  Write-Host "[OK] Landing page up" -ForegroundColor Green
} catch {
  Write-Host "[WARN] Landing check failed" -ForegroundColor Yellow
}

$cfg = Get-Content (Join-Path $Root "config\business.json") -Raw | ConvertFrom-Json
if ($cfg.businessEmail -match '@') {
  Write-Host "[OK] Business email: $($cfg.businessEmail)" -ForegroundColor Green
} else {
  Write-Host "[FAIL] businessEmail missing in config" -ForegroundColor Red
  $fail++
}

$envFile = Join-Path $Root "apps\afterline\.env"
$envText = Get-Content $envFile -Raw
if ($envText -match 'TWILIO_ACCOUNT_SID=\S+') {
  Write-Host "[OK] Twilio SID configured" -ForegroundColor Green
} else {
  Write-Host "[WARN] Twilio not configured - SMS simulated" -ForegroundColor Yellow
}

try {
  $test = @{
    name = "Verify Test"
    company = "Optimal Flow Agency"
    phone = "+15550009999"
    email = "verify@test.local"
    message = "Automated verify-all test"
  } | ConvertTo-Json
  $lead = Invoke-RestMethod -Uri "http://localhost:3847/api/book-audit" -Method POST -ContentType "application/json" -Body $test
  Write-Host "[OK] Book-audit API saves leads (id=$($lead.lead.id))" -ForegroundColor Green
} catch {
  Write-Host "[FAIL] Book-audit API" -ForegroundColor Red
  $fail++
}

$startup = Join-Path ([Environment]::GetFolderPath("Startup")) "Afterline-API.lnk"
if (Test-Path $startup) {
  Write-Host "[OK] Windows autostart installed" -ForegroundColor Green
} else {
  Write-Host "[WARN] Autostart not installed" -ForegroundColor Yellow
}

Write-Host ""
if ($fail -eq 0) {
  Write-Host "All critical checks passed." -ForegroundColor Green
} else {
  Write-Host "$fail critical check(s) failed." -ForegroundColor Red
}
Write-Host "Manual: activate FormSubmit in Outlook (search FormSubmit)." -ForegroundColor Cyan
Write-Host ""
