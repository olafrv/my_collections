#!/bin/bash

# Speech to Text using Open AI Whisper
# https://openai.com/index/whisper/

# apt install ffmpeg
# pip install openai-whisper ffmpeg

import whisper
model = whisper.load_model("small")  # or turbo, medium or large.
result = model.transcribe("audio.mpeg", language="de")
print(result["text"])
