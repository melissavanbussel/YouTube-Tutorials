# Load packages
library(openai)

# Create transcription
my_transcription <- create_transcription(
  file = "Image classification and object detection.mp4",
  model = "whisper-1"
)

# Extract results
my_transcription$text
