# === PhantomNet LIVE Launcher ===

# Set working directory
$projectPath = "C:\Users\1Man.Army\phantomnet"
cd $projectPath

# Pull latest (already synced, but clean just in case)
git pull origin main

# Ensure logs folder exists
$logPath = "$projectPath\logs"
if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath
}

# Launch main PhantomNet script in separate PowerShell window
Write-Host "`n🚀 Starting PhantomNet.ps1..."
Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-File `"$projectPath\PhantomNet.ps1`""

# Wait for PhantomNet to boot
Start-Sleep -Seconds 3

# Tail the results log in real time
Write-Host "`n📡 Live logs from PhantomNet:"
Get-Content "$logPath\results.log" -Wait
