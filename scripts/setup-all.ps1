# One script - full Afterline setup (run once, then START.ps1 daily)
param([switch]$SkipTwilio)

$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root
$env:Path = "C:\Users\Trave\.bun\bin;C:\Program Files\nodejs;" + $env:Path

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AFTERLINE FULL SETUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n[1/8] Applying config..." -ForegroundColor Gray
node "$Root\scripts\apply-config.mjs"

Write-Host "[2/8] Installing API..." -ForegroundColor Gray
Push-Location "$Root\apps\afterline"
npm install --silent 2>$null
npm run setup 2>$null
Pop-Location

$envPath = Join-Path $Root "apps\afterline\.env"
$envText = Get-Content $envPath -Raw
if ($envText -notmatch 'NOTIFY_EMAIL') {
  Add-Content $envPath "`nNOTIFY_EMAIL=deallomcconnell@optimalflowagency.io`nNOTIFY_CC=deallomcconnell@gmail.com`nBUSINESS_EMAIL=deallomcconnell@optimalflowagency.io"
}

Write-Host "[3/8] Starting API..." -ForegroundColor Gray
Get-NetTCPConnection -LocalPort 3847 -ErrorAction SilentlyContinue |
  ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 1
Start-Process powershell -ArgumentList "-WindowStyle", "Hidden", "-ExecutionPolicy", "Bypass", "-File", "`"$Root\scripts\run-api.ps1`""
Start-Sleep -Seconds 3

Write-Host "[4/8] Installing Windows autostart..." -ForegroundColor Gray
& "$Root\scripts\install-autostart.ps1"

Write-Host "[5/8] Pinging FormSubmit..." -ForegroundColor Gray
try {
  $body = '{"name":"Deallo","company":"Setup Test","phone":"+18700000000","email":"deallomcconnell@optimalflowagency.io","message":"Setup test","_subject":"Afterline activate","_template":"table","_captcha":"false"}'
  Invoke-RestMethod -Uri "https://formsubmit.co/ajax/deallomcconnell@optimalflowagency.io" -Method POST -ContentType "application/json" -Body $body | Out-Null
} catch {}

Write-Host "[6/8] Twilio..." -ForegroundColor Gray
$tw = Get-Content $envPath -Raw
if ($tw -notmatch 'TWILIO_ACCOUNT_SID=\S' -and -not $SkipTwilio) {
  Write-Host "  Press Enter to skip Twilio, or type setup:" -ForegroundColor Yellow
  $ans = Read-Host
  if ($ans -eq "setup") { & "$Root\scripts\setup-twilio.ps1" }
} else {
  Write-Host "  Twilio skipped (run scripts\setup-twilio.ps1 when ready)" -ForegroundColor Gray
}

Write-Host "[7/8] Running checks..." -ForegroundColor Gray
& "$Root\scripts\verify-all.ps1"

Write-Host "[8/8] Git sync..." -ForegroundColor Gray
git add -A 2>$null
git diff --cached --quiet 2>$null
if ($LASTEXITCODE -ne 0) {
  git commit -m "Setup-all sync" 2>$null
  git push 2>$null
}

Write-Host ""
Write-Host "SETUP COMPLETE" -ForegroundColor Green
Write-Host "  Landing: https://ofa-code.github.io/afterline/"
Write-Host "  Admin:   http://localhost:3847/admin.html"
Write-Host "  Outlook: search FormSubmit and click Activate (one time)"
Write-Host "  Render:  https://render.com/deploy?repo=https://github.com/OFA-code/afterline"
Write-Host ""

Start-Process "http://localhost:3847/admin.html"
Start-Process "https://ofa-code.github.io/afterline/book.html"
Start-Process "$Root\tools\outbox"
