# Executes launch steps that do not need your inbox password.
$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

Write-Host ""
Write-Host "=== Afterline execute-launch ===" -ForegroundColor Cyan

node "$Root\scripts\apply-config.mjs"

$body = @{
  name = "Deallo (system test)"
  company = "Optimal Flow Agency"
  phone = "+15550001111"
  email = "deallomcconnell@gmail.com"
  message = "Automated test. Ignore unless FormSubmit needs activation."
  _subject = "Afterline booking test"
  _template = "table"
  _captcha = "false"
  _cc = "deallomcconnell@gmail.com"
} | ConvertTo-Json

try {
  Invoke-RestMethod -Uri "https://formsubmit.co/ajax/deallomcconnell@optimalflowagency.io" -Method POST -ContentType "application/json" -Body $body
  Write-Host "FormSubmit ping sent. Check agency inbox for activation." -ForegroundColor Green
} catch {
  Write-Host "FormSubmit ping failed." -ForegroundColor Yellow
}

try {
  $null = Invoke-WebRequest -Uri "http://localhost:3847/api/health" -UseBasicParsing -TimeoutSec 2
} catch {
  Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$Root\apps\afterline'; node server.js" -WindowStyle Minimized
  Start-Sleep -Seconds 2
}

$dirty = git status --porcelain
if ($dirty) {
  git add -A
  git commit -m "Auto deploy from execute-launch" 2>$null
  git push 2>&1
}

& "$Root\scripts\daily-start.ps1"

Write-Host ""
Write-Host "Outbox ready: tools\outbox\SEND-TODAY.md" -ForegroundColor Cyan
Start-Process "$Root\tools\outbox"
