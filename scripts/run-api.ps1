# Keeps Afterline API running (used by Windows Startup)
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ApiDir = Join-Path $Root "apps\afterline"
$env:Path = "C:\Users\Trave\.bun\bin;C:\Program Files\nodejs;" + $env:Path
$env:NOTIFY_EMAIL = "deallomcconnell@optimalflowagency.io"
$env:NOTIFY_CC = "deallomcconnell@gmail.com"
$env:BUSINESS_EMAIL = "deallomcconnell@optimalflowagency.io"

Set-Location $ApiDir
while ($true) {
  try {
    node server.js
  } catch {}
  Start-Sleep -Seconds 5
}
