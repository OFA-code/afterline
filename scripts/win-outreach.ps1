# Open outreach dashboard + first email draft in Outlook
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$launch = Join-Path $Root "tools\outbox\launch.html"
$tracker = Join-Path $Root "tools\LEAD-TRACKER.csv"

Write-Host ""
Write-Host "AFTERLINE WIN OUTREACH" -ForegroundColor Cyan
Write-Host ""

Start-Process $launch
Start-Process $tracker
Start-Process (Join-Path $Root "sales\AUDIT-CALL.md")
Start-Process (Join-Path $Root "sales\CLOSE-ONE-PAGE.md")

# Open Serveway email in Outlook (only lead with known email)
try {
  $ol = New-Object -ComObject Outlook.Application
  $mail = $ol.CreateItem(0)
  $mail.To = "janalreid@outlook.com"
  $mail.Subject = "missed calls - remote follow-up for Serveway"
  $mail.Body = @"
Hi Brian,

Serveway's reviews stand out in Dallas - phones must be busy in season.

When a call is missed on a job, does anyone text back same day? We help HVAC shops automate that in your voice - 100% remote.

`$497 pilot / 30 days. One recovered job usually covers it.

https://ofa-code.github.io/afterline/book.html

- Deallo | Afterline | Optimal Flow Agency
"@
  $mail.Display()
  Write-Host "[OK] Outlook draft opened for Serveway (janalreid@outlook.com)" -ForegroundColor Green
} catch {
  Write-Host "[WARN] Could not open Outlook - use launch.html mailto button" -ForegroundColor Yellow
  Start-Process "C:\Users\Trave\Projects\ai-business\tools\outbox\09-serveway.url"
}

Write-Host ""
Write-Host "TODAY:" -ForegroundColor Yellow
Write-Host "  1. Send Serveway email (draft open)"
Write-Host "  2. CALL Richard's Hardy (870) 856-3853 - use Copy message in dashboard"
Write-Host "  3. Mark sent in dashboard after each touch"
Write-Host ""
