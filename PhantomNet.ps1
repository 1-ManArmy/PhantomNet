# ✅ PhantomNet PowerShell CLI - End Level Drop 🔥
# Location: C:\Users\1Man.Army\phantomnet

[CmdletBinding()]
param (
    [Parameter()] [string] $IP = "127.0.0.1",
    [Parameter()] [string] $Task = "sysinfo",
    [Parameter()] [string] $Path = "C:\\",
    [Parameter()] [switch] $Stealth,
    [Parameter()] [switch] $Deploy,
    [Parameter()] [switch] $Log,
    [Parameter()] [switch] $Report,
    [Parameter()] [switch] $KillSession
)

function Encrypt-Data {
    param ([string]$data)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($data)
    $encrypted = [Convert]::ToBase64String($bytes)
    return $encrypted
}

function Decrypt-Data {
    param ([string]$data)
    $bytes = [Convert]::FromBase64String($data)
    $decoded = [System.Text.Encoding]::UTF8.GetString($bytes)
    return $decoded
}

function Deploy-Agent {
    Write-Host "[+] Deploying Agent to $IP ..." -ForegroundColor Cyan
    $sessionID = "Session_$([guid]::NewGuid().ToString().Substring(0, 6))"
    $logPath = ".\logs\$sessionID.json"
    $payload = @{ task = $Task; ip = $IP; timestamp = (Get-Date); stealth = $Stealth.IsPresent }
    $json = $payload | ConvertTo-Json -Depth 4
    $encoded = Encrypt-Data -data $json
    $encoded | Out-File $logPath
    Write-Host "[📄] Agent Log: $logPath" -ForegroundColor Yellow
    return $sessionID
}

function Generate-Report {
    param ([string]$sessionID)
    $logFile = ".\logs\$sessionID.json"
    if (Test-Path $logFile) {
        $content = Get-Content $logFile | Out-String
        $decoded = Decrypt-Data -data $content
        $reportPath = ".\reports\$sessionID.txt"
        $decoded | Out-File $reportPath
        Write-Host "[📁] Report Generated: $reportPath" -ForegroundColor Green
    } else {
        Write-Host "[x] Log not found for session $sessionID" -ForegroundColor Red
    }
}

function Kill-Agent {
    param ([string]$sessionID)
    Write-Host "[!] Terminating Session: $sessionID" -ForegroundColor Red
    $logFile = ".\logs\$sessionID.json"
    if (Test-Path $logFile) {
        Remove-Item $logFile
        Write-Host "[✔] Session log deleted." -ForegroundColor Green
    }
}

function Ghost-Screen {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $screenshotPath = ".\logs\screenshot_$timestamp.png"
    $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "[📸] Screenshot captured: $screenshotPath" -ForegroundColor Magenta
}

function Ghost-Cam {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Add-Type -TypeDefinition @"
    using System;
    using System.Drawing;
    using System.Windows.Forms;
    using System.Runtime.InteropServices;
    public class WebCamSnap {
        [DllImport("avicap32.dll", EntryPoint="capCreateCaptureWindow")] public static extern IntPtr capCreateCaptureWindow(string lpszWindowName, int dwStyle, int x, int y, int nWidth, int nHeight, IntPtr hwndParent, int nID);
        [DllImport("user32.dll")] public static extern bool SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
    }
"@
    $cam = [WebCamSnap]::capCreateCaptureWindow("WebCap", 0x40000000, 0, 0, 640, 480, 0, 0)
    $bitmap = New-Object Drawing.Bitmap 640, 480
    $graphics = [Drawing.Graphics]::FromImage($bitmap)
    $graphics.Clear([Drawing.Color]::Black)
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $path = ".\logs\webcam_$timestamp.png"
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "[📷] Webcam image saved: $path" -ForegroundColor Cyan
}

function Ghost-FS {
    Write-Host "[📁] Exploring: $Path" -ForegroundColor Cyan
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | \
            Select-Object FullName, Length, LastWriteTime | \
            Export-Csv -Path ".\logs\fs_dump_$(Get-Date -Format yyyyMMdd_HHmmss).csv" -NoTypeInformation
        Write-Host "[📊] FS Dump Completed" -ForegroundColor Green
    } else {
        Write-Host "[x] Path not found: $Path" -ForegroundColor Red
    }
}

Write-Host "\n🔥 PhantomNet CLI Loaded. Awaiting Orders..." -ForegroundColor Green

if ($Deploy) {
    $sid = Deploy-Agent
}

if ($Log) {
    Get-ChildItem .\logs\*.json | ForEach-Object {
        Write-Host "[LOG] $_"
    }
}

if ($Report -and $sid) {
    Generate-Report -sessionID $sid
}

if ($KillSession -and $sid) {
    Kill-Agent -sessionID $sid
}

switch ($Task.ToLower()) {
    "screenshot" { Ghost-Screen }
    "ghostcam"   { Ghost-Cam }
    "ghostfs"    { Ghost-FS }
}

Write-Host "\n🎯 Mission Complete." -ForegroundColor Cyan
