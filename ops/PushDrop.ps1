Set-Location "C:\Users\1Man.Army\phantomnet"

git add .\reports\*.7z
git commit -m "🔐 Auto-pushed encrypted drop"
git push origin main

Write-Host "[🚀] Drop uploaded to GitHub repo: AI_King_Battle" -ForegroundColor Cyan
