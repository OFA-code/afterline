# Interactive Twilio setup — paste keys from console.twilio.com
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$EnvFile = Join-Path $Root "apps\afterline\.env"

Write-Host ""
Write-Host "Twilio setup (https://console.twilio.com)" -ForegroundColor Cyan
Write-Host "Get: Account SID, Auth Token, and buy/get a phone number with SMS."
Write-Host ""

$sid = Read-Host "TWILIO_ACCOUNT_SID"
$token = Read-Host "TWILIO_AUTH_TOKEN"
$from = Read-Host "TWILIO_FROM_NUMBER (E.164 e.g. +18705551234)"

if (-not $sid -or -not $token -or -not $from) {
  Write-Host "Skipped — add keys to apps\afterline\.env later." -ForegroundColor Yellow
  exit 0
}

$text = Get-Content $EnvFile -Raw
$text = $text -replace 'TWILIO_ACCOUNT_SID=.*', "TWILIO_ACCOUNT_SID=$sid"
$text = $text -replace 'TWILIO_AUTH_TOKEN=.*', "TWILIO_AUTH_TOKEN=$token"
$text = $text -replace 'TWILIO_FROM_NUMBER=.*', "TWILIO_FROM_NUMBER=$from"
Set-Content $EnvFile $text -NoNewline

Write-Host "Twilio saved to .env" -ForegroundColor Green
Write-Host "In Twilio console set webhooks to your public API URL (see SETUP-ALL.md Render deploy)."
