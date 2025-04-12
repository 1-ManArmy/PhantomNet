param([string]$Command = "whoami", [switch]$Silent)
function Run-Stealth { try { $r = Invoke-Expression $Command; if (-not $Silent) { Write-Host $r } } catch {} }
Run-Stealth
