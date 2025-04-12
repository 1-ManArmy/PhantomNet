Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$duration = 5  # seconds
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$path = ".\logs\mic_$timestamp.wav"

$recorder = New-Object -ComObject "SoundRecorder.SoundRecorder"
$recorder.Filename = (Resolve-Path $path).Path
$recorder.Duration = $duration
$recorder.Record()

Write-Host "[🎙️] Mic audio captured to $path" -ForegroundColor Green
