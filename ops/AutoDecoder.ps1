param([string]$Encoded)

try {
    $decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Encoded))
    Write-Host "[🔓] Decoded Base64: $decoded" -ForegroundColor Green
} catch {
    Write-Host "[x] Invalid Base64 or corrupted input." -ForegroundColor Red
}
