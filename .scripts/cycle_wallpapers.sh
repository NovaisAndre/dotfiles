#!/bin/bash

# Lock file path (can be anywhere, /tmp is common)
LOCKFILE="/tmp/cycle_wallpapers.lock"

# Try to acquire lock (non-blocking, exit if already running)
exec 200>"$LOCKFILE"
flock -n 200 || exit 1

WALLPAPER_DIR="$HOME/.wallpapers"
DISTRIBUTED_DIR="$HOME/.wallpapers/distributed"

CHANGE_INTERVAL=180 

while true; do
    # Get a random wallpaper from the directory
    # wallpaper=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
    wallpaper=$(find "$WALLPAPER_DIR" -type f -not -path '*/archive/*' | shuf -n 1)
    feh --bg-max "$wallpaper"

    name=$(basename "$wallpaper")
    name="${name%.*}"
    sound="$HOME/.sounds/wallpapers/$name.mp3"
    # [ -f "$sound" ] && mpv --no-video --really-quiet --volume=100 "$sound" &

    sleep $CHANGE_INTERVAL
done

