#!/bin/bash

# Simple emoji list (can expand later)
emojis="😀 Grinning
😂 Laughing
😍 Heart Eyes
🥳 Party
😎 Cool
😢 Crying
🤔 Thinking
👍 Thumbs Up
🔥 Fire
🎉 Tada
❤️ Heart
🚀 Rocket
🍕 Pizza
⚡ Zap
🐱 Cat
🐶 Dog
🌍 Earth
💡 Lightbulb
📚 Books
🎮 Gamepad"

# Pick with dmenu
chosen=$(echo "$emojis" | dmenu -i -l 10 | awk '{print $1}')

# If something was chosen
[ -n "$chosen" ] || exit 1

# Copy to clipboard
echo -n "$chosen" | xclip -selection clipboard

# Paste into current window (optional)
xdotool key ctrl+v

