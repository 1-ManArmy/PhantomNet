Write-Host "[🧠] OpsCenter Loaded" -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File ..\PhantomNet.ps1 -Task "screenshot"
powershell -ExecutionPolicy Bypass -File ..\agent\GhostBot.ps1 -Command "hostname"
