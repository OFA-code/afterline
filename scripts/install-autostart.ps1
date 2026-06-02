# Register Afterline API to start when Windows logs in
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Runner = Join-Path $Root "scripts\run-api.ps1"
$Startup = [Environment]::GetFolderPath("Startup")
$ShortcutPath = Join-Path $Startup "Afterline-API.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$Runner`""
$Shortcut.WorkingDirectory = $Root
$Shortcut.Description = "Afterline SMS API"
$Shortcut.Save()

Write-Host "Autostart installed: $ShortcutPath" -ForegroundColor Green
