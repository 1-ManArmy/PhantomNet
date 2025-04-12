Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Mock-WebcamSnap {
    $bmp = New-Object Drawing.Bitmap 320, 240
    $gfx = [Drawing.Graphics]::FromImage($bmp)
    $gfx.Clear([Drawing.Color]::Black)

    $font = New-Object Drawing.Font("Arial", 20)
    $brush = [Drawing.Brushes]::White
    $gfx.DrawString("MockCam Activated", $font, $brush, 20, 100)

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $path = ".\logs\webcam_$timestamp.png"
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)

    Write-Host "[📷] Webcam mock image saved: $path" -ForegroundColor Cyan
}

Mock-WebcamSnap
