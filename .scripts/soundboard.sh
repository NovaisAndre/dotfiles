#!/usr/bin/env bash

SOUNDS_DIR="$HOME/.sounds"
volume=75

sound=$(find "$SOUNDS_DIR" -type f | dmenu -i -l 20 -p "Select sound:")

if [ -n "$sound" ]; then
    # Play to your speakers (default)
    mpv --no-video --really-quiet --volume=$volume "$sound" &

    # Play to virtual sink (for Discord)
    PULSE_SINK=virtual_sink mpv  --no-video --really-quiet --volume=$volume "$sound" &
fi
