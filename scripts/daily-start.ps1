# Daily start — opens your operating stack
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "`nAfterline — daily start`n" -ForegroundColor Cyan

$apiRunning = $false
try {
  $null = Invoke-WebRequest -Uri "http://localhost:3847/api/health" -UseBasicParsing -TimeoutSec 2
  $apiRunning = $true
} catch {}

if (-not $apiRunning) {
  Write-Host "Starting API..." -ForegroundColor Gray
  Start-Process powershell -ArgumentList "-NoExit","-Command","cd '$Root\apps\afterline'; node server.js" -WindowStyle Minimized
  Start-Sleep -Seconds 2
}

Start-Process "$Root\tools\LEAD-TRACKER.csv"
Start-Process "$Root\operations\DAILY-RHYTHM.md"
Start-Process "$Root\marketing\outreach\PLAYBOOK.md"
Start-Process "http://localhost:3847/admin.html"
Start-Process "https://ofa-code.github.io/afterline/book.html"

Write-Host "Open: LEAD-TRACKER, daily checklist, outreach playbook, admin, booking page"
Write-Host "Read: OPERATING-SYSTEM.md`n"
