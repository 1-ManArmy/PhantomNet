import requests

def send_alert(message):
    webhook_url = "https://discordapp.com/api/webhooks/1360051197012348958/WBKTD47_C3kVUnhDe4CSntTW4SSFE3CClnd9fAwPVp71xFh_vdipyo_3S8__rxypUD76"
    payload = {
        "content": f"📡 PhantomNet Alert:\n```{message}```"
    }
    try:
        requests.post(webhook_url, json=payload)
    except Exception as e:
        print(f"[x] Discord webhook failed: {e}")
