#!/bin/bash

# Get current volume as an integer (first channel)
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -n1)

case "$1" in
  up)
    if [ "$current_volume" -lt 100 ]; then
      pactl set-sink-volume @DEFAULT_SINK@ +3%
    fi
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -3%
    ;;
  up20)
    if [ "$current_volume" -lt 100 ]; then
      pactl set-sink-volume @DEFAULT_SINK@ +20%
    fi
    ;;
  down20)
    pactl set-sink-volume @DEFAULT_SINK@ -20%
    ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;
esac

# Get volume and mute state
volume_raw=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1)
volume=${volume_raw%\%}
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Choose icon
if [ "$mute" = "yes" ]; then
  icon="🔇"
  bar="────────────"
elif [ "$volume" -lt 30 ]; then
  icon="🔈"
elif [ "$volume" -lt 70 ]; then
  icon="🔉"
else
  icon="🔊"
fi

# Create volume bar (12 chars wide)
bar_length=$((volume * 12 / 100))
filled=$(printf '█%.0s' $(seq 1 $bar_length))
empty=$(printf '─%.0s' $(seq 1 $((12 - bar_length))))
bar="$filled$empty"

# Use dunstify if available, else fallback
if command -v dunstify &> /dev/null; then
  dunstify -a Volume -r 91190 -u low "$icon  $bar $volume%"
else
  notify-send -a Volume -u low "$icon  Volume: $volume%"
fi

