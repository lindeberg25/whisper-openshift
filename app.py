from flask import Flask, abort, request
from tempfile import NamedTemporaryFile
import whisper
import torch

# Check if NVIDIA GPU is available
#torch.cuda.is_available()
#DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

# Load the Whisper model:
model = whisper.load_model("base", device=DEVICE)

app = Flask(__name__)


@app.route("/")
def hello():
    return "Whisper Hello World!"


