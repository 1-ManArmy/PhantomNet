import os
from dotenv import load_dotenv
import openai

# Load environment variables from .env
load_dotenv()

# Assign API key from env
openai.api_key = os.getenv("OPENAI_API_KEY")

# Confirm API key loaded
if not openai.api_key:
    print("❌ Error: OPENAI_API_KEY not found in .env file.")
else:
    print("🔐 OpenAI API key loaded successfully.")
