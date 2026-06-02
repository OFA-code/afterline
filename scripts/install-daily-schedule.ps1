# Schedule Afterline daily-start at 8:00 AM (local time)
param(
  [string]$Time = "08:00",
  [string]$FirstRunDate = ""  # yyyy-MM-dd, empty = today
)

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$script = Join-Path $Root "scripts\daily-start.ps1"
$taskName = "Afterline-Daily-8AM"

if (-not (Test-Path $script)) {
  Write-Error "Missing: $script"
  exit 1
}

$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
  Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$hour, $minute = $Time -split ':'
$at = Get-Date -Hour ([int]$hour) -Minute ([int]$minute) -Second 0

if ($FirstRunDate) {
  $start = [datetime]::ParseExact($FirstRunDate, 'yyyy-MM-dd', $null)
  $at = Get-Date -Year $start.Year -Month $start.Month -Day $start.Day -Hour ([int]$hour) -Minute ([int]$minute) -Second 0
}

$action = New-ScheduledTaskAction `
  -Execute "powershell.exe" `
  -Argument "-ExecutionPolicy Bypass -File `"$script`""

$trigger = New-ScheduledTaskTrigger -Daily -At $at
if ($FirstRunDate) {
  $trigger.StartBoundary = $at.ToString('yyyy-MM-ddTHH:mm:ss')
}

$settings = New-ScheduledTaskSettingsSet `
  -AllowStartIfOnBatteries `
  -DontStopIfGoingOnBatteries `
  -StartWhenAvailable `
  -ExecutionTimeLimit (New-TimeSpan -Hours 1)

$principal = New-ScheduledTaskPrincipal `
  -UserId $env:USERNAME `
  -LogonType Interactive `
  -RunLevel Limited

Register-ScheduledTask `
  -TaskName $taskName `
  -Action $action `
  -Trigger $trigger `
  -Settings $settings `
  -Principal $principal `
  -Description "Opens Afterline daily stack: API, admin, leads, outreach at 8 AM" | Out-Null

Write-Host "Scheduled: $taskName"
Write-Host "  Script:  $script"
Write-Host "  Time:    daily at $Time (local)"
Write-Host "  First:   $($trigger.StartBoundary)"
Write-Host "  User:    $env:USERNAME (must be logged in to open windows)"
Write-Host ""
Write-Host "Test now:  Start-ScheduledTask -TaskName '$taskName'"
Write-Host "Remove:    Unregister-ScheduledTask -TaskName '$taskName' -Confirm:`$false"
