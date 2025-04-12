import socketio

sio = socketio.Client()
sio.connect("http://localhost:8080")

@sio.on("response")
def on_response(data):
    print("[🧠 TOKEN RECEIVED]")
    token = data["token"]
    sio.emit("execute", {"token": token})

@sio.on("result")
def on_result(data):
    print("[🎯 RESULT]")
    print(data)
    sio.disconnect()

sio.emit("deploy", {"cmd": "whoami"})
sio.wait()
