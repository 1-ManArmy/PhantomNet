import subprocess
import os
import time
import platform
import webbrowser

# === PhantomNet Unified Launcher ===
print("\n🚀 Welcome to PhantomNet: Unified Ops Mode 🕶️\n")

# Settings
web_app = "web/app.py"
ngrok_path = "tools/ngrok.exe"  # Adjust path if needed
port = "5000"

# Confirm environment
system = platform.system()
print(f"[🧠] Detected OS: {system}")

# Ask how user wants to launch
mode = input("[❓] Launch Flask + ngrok in PowerShell windows? (y/N): ").strip().lower()

if mode == "y" and system == "Windows":
    print("[⚡] Launching in separate PowerShell terminals...")
    subprocess.Popen(["powershell", "-NoExit", "-Command", f"python {web_app}"])
    time.sleep(2)
    subprocess.Popen(["powershell", "-NoExit", "-Command", f"{ngrok_path} http {port}"])
else:
    print("[🧪] Running in current Python terminal...")
    flask_proc = subprocess.Popen(["python", web_app])
    time.sleep(2)
    ngrok_proc = subprocess.Popen([ngrok_path, "http", port])
    time.sleep(3)

# Optional: Open browser to local dashboard
webbrowser.open(f"http://localhost:{port}")
print(f"[✅] Dashboard should be live at http://localhost:{port}")
print("[📡] Check ngrok terminal for your public link.")
