param (
    [string]$SourceFolder = ".\logs",
    [string]$ZipName = "drop.zip",
    [string]$Password = "Professor123"
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$finalZip = ".\reports\$($timestamp)_$ZipName"

if (-not (Test-Path ".\reports")) { mkdir .\reports | Out-Null }

Compress-Archive -Path "$SourceFolder\*" -DestinationPath $finalZip

& "$env:ProgramFiles\7-Zip\7z.exe" a -p$Password "$finalZip.7z" "$finalZip"
Remove-Item $finalZip

Write-Host "[🔐] Encrypted drop created: $finalZip.7z" -ForegroundColor Cyan
