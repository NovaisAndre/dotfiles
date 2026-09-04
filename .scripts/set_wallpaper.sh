#!/bin/bash

# Path to the directory containing wallpapers
WALLPAPER_DIR="$HOME/.wallpapers"

# Get a list of wallpapers and display them in dmenu
wallpaper=$(find "$WALLPAPER_DIR" -type f | dmenu -i -l 20 -p "Select wallpaper:")

# If a wallpaper is selected, set it using feh
if [ -n "$wallpaper" ]; then
    feh --bg-max "$wallpaper"

    name=$(basename "$wallpaper")
    name="${name%.*}"
    sound="$HOME/.sounds/wallpapers/$name.mp3"
    [ -f "$sound" ] && mpv --no-video --really-quiet --volume=75 "$sound" &
else
    echo "No wallpaper selected."
fi

