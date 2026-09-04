#!/bin/bash

# Path to the directory containing sounds
SOUNDS_DIR="$HOME/.sounds"

# Get a list of sounds and display them in dmenu
sound=$(find "$SOUNDS_DIR" -type f | dmenu -i -l 20 -p "Select sound:")

# If a sound is selected, play using mpv
if [ -n "$sound" ]; then
    mpv --no-video "$sound"
else
    echo "No sound selected."
fi

