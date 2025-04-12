Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$duration = 30
$interval = 3
if ($args.Count -ge 1) { $duration = [int]$args[0] }
if ($args.Count -ge 2) { $interval = [int]$args[1] }

function Stream-Frame {
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
    $bmp.Save(".\logs\stream\frame_$stamp.png", [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "[📡] Frame saved: frame_$stamp.png" -ForegroundColor DarkGray
}

$end = (Get-Date).AddSeconds($duration)
while ((Get-Date) -lt $end) {
    Stream-Frame
    Start-Sleep -Seconds $interval
}
Write-Host "[✅] GhostPulse session complete." -ForegroundColor Green
