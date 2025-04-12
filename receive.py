from flask import Flask, request

app = Flask(__name__)

@app.route("/receive", methods=["POST"])
def recv():
    data = request.json
    print("[📡] Payload Received:", data)
    return "ACK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
