# PhantomNet Full Setup Script
Write-Host "[💻] Starting PhantomNet Environment Setup..."

# Navigate to PhantomNet project folder
Set-Location "$env:USERPROFILE\phantomnet"

# Create virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1

# Upgrade pip
python -m pip install --upgrade pip

# Install Python dependencies
pip install flask flask_socketio eventlet discord requests

# Download ngrok (64-bit)
$ngrokZip = "$env:USERPROFILE\Downloads\ngrok.zip"
$toolsPath = "$env:USERPROFILE\phantomnet\tools"
Invoke-WebRequest -Uri "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip" -OutFile $ngrokZip
Expand-Archive -Path $ngrokZip -DestinationPath $toolsPath -Force
Remove-Item $ngrokZip

# Setup ngrok.yml if not already placed
$ngrokConfigPath = "$env:USERPROFILE\.ngrok2"
if (!(Test-Path $ngrokConfigPath)) {
    New-Item -Path $ngrokConfigPath -ItemType Directory -Force
}
Copy-Item ".\ngrok.yml" -Destination "$ngrokConfigPath\ngrok.yml" -Force

Write-Host "[✅] PhantomNet setup complete. You may now launch with: python phantom_launcher.py"