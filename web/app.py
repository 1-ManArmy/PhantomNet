from flask import Flask, request, redirect, render_template_string, session, jsonify
from flask_socketio import SocketIO, send
from werkzeug.security import check_password_hash
import subprocess, os, json, time

app = Flask(__name__)
app.config['SECRET_KEY'] = 'phantomnet_secure_key'
socketio = SocketIO(app)

USERNAME = "johnny"
PASSWORD_HASH = "example$hashed_password_here"  # Replace with actual hash

# HTML templates
dashboard_html = "<h1>PhantomNet Dashboard</h1><p>Live Commands:</p><div id='terminal'></div>"
login_html = """<form method='post'><input name='user'/><input name='pass' type='password'/><button>Login</button></form>"""

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        if request.form.get("user") == USERNAME and check_password_hash(PASSWORD_HASH, request.form.get("pass", "")):
            session["logged_in"] = True
            return redirect("/dashboard")
        return "Invalid credentials", 403
    return render_template_string(login_html)

@app.route("/dashboard")
def dashboard():
    if not session.get("logged_in"):
        return redirect("/")
    return render_template_string(dashboard_html)

@socketio.on("message")
def command_exec(cmd):
    if not session.get("logged_in"):
        return
    try:
        output = subprocess.check_output(["powershell", "-Command", cmd], stderr=subprocess.STDOUT, text=True)
    except subprocess.CalledProcessError as e:
        output = e.output
    with open("logs/output.log", "a", encoding="utf-8") as f:
        f.write(f">>> {cmd}\\n{output}\\n")
    send(output)

@app.route("/receive", methods=["POST"])
def recv():
    os.makedirs("logs", exist_ok=True)
    log_path = "logs/messages.json"
    if not os.path.exists(log_path):
        with open(log_path, "w") as f:
            json.dump([], f)
    data = request.json
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    message = {
        "id": f"MSG-{int(time.time())}",
        "timestamp": timestamp,
        "sender": data.get("sender", "Unknown"),
        "message": data.get("message", ""),
        "status": "received"
    }
    with open(log_path, "r+", encoding="utf-8") as f:
        logs = json.load(f)
        logs.append(message)
        f.seek(0)
        json.dump(logs, f, indent=2)
    return jsonify({"status": "ok", "received": message})

if __name__ == "__main__":
    os.makedirs("logs", exist_ok=True)
    socketio.run(app, host="0.0.0.0", port=5000)