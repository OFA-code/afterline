# Afterline — one script to configure, deploy landing, start API
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

Write-Host "`n=== Afterline Go Live ===" -ForegroundColor Cyan

$cfgPath = Join-Path $Root "config\business.json"
$cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json

if ($cfg.businessEmail -match 'CHANGE_ME') {
  Write-Host "`nEnter the email where you want audit requests (Gmail is fine):" -ForegroundColor Yellow
  $email = Read-Host "Business email"
  if ($email) {
    $cfg.businessEmail = $email.Trim()
    $cfg | ConvertTo-Json -Depth 5 | Set-Content $cfgPath -Encoding utf8
  }
}

node "$Root\scripts\apply-config.mjs"

$secret = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object { [char]$_ })
$envPath = Join-Path $Root "apps\afterline\.env"
$envText = Get-Content $envPath -Raw
if ($envText -match 'change-me-to-random-string') {
  $envText = $envText -replace 'change-me-to-random-string', $secret
  Set-Content $envPath $envText -NoNewline
  Write-Host "Admin secret saved to apps\afterline\.env" -ForegroundColor Green
}

Write-Host "`nInstalling API dependencies..." -ForegroundColor Gray
Push-Location "$Root\apps\afterline"
if (-not (Test-Path node_modules)) { npm install --silent }
npm run setup 2>$null
Pop-Location

Write-Host "`nDeploying landing to GitHub Pages..." -ForegroundColor Gray
$repo = "$($cfg.githubUser)/$($cfg.repoName)"
$remoteExists = git remote get-url origin 2>$null
if (-not $remoteExists) {
  gh repo create $cfg.repoName --public --description "Afterline — home service follow-up" --source=. --remote=origin 2>$null
  if ($LASTEXITCODE -ne 0) {
    git remote add origin "https://github.com/$repo.git" 2>$null
  }
}

git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  git commit -m "Afterline go-live: landing, API, outreach"
}
git branch -M main 2>$null
git push -u origin main 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Host "Push failed — log in with: gh auth login" -ForegroundColor Yellow
} else {
  Write-Host "Repo: https://github.com/$repo" -ForegroundColor Green
  Write-Host "Pages (1–2 min): https://$($cfg.githubUser).github.io/$($cfg.repoName)/" -ForegroundColor Green
}

Write-Host "`nStarting Afterline API..." -ForegroundColor Gray
$apiDir = Join-Path $Root "apps\afterline"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$apiDir'; node server.js" -WindowStyle Minimized

Start-Sleep -Seconds 2
$landing = "https://$($cfg.githubUser).github.io/$($cfg.repoName)/"
Start-Process "http://localhost:3847/admin.html"
Start-Process $landing
Start-Process "http://localhost:3847/../../marketing/landing/book.html" 2>$null
Start-Process (Join-Path $Root "marketing\outreach\ready")

Write-Host "`n=== Done ===" -ForegroundColor Green
Write-Host "Admin:    http://localhost:3847/admin.html"
Write-Host "Landing:  $landing"
Write-Host "Outreach: marketing\outreach\ready (open mailto files)"
Write-Host "`nTwilio (optional): https://console.twilio.com — paste keys in apps\afterline\.env"
Write-Host "Edit city/trade: config\business.json then run: node scripts\apply-config.mjs`n"
