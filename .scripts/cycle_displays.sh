#!/usr/bin/env bash

# List of predefined layouts (order matters)
layouts=(
    # "xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x0 --rotate normal --output HDMI-1 --off --rate 40"
    # "xrandr --output eDP-1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-1 --off --rate 40"
    # "xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x1080 --rotate normal --output HDMI-1 --mode 1280x720 --pos 0x0 --rotate normal"
    # "xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x1080 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal"
    # "xrandr --output eDP-1 --primary --mode 1280x720 --pos 0x2160 --rotate normal --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal"
    # "xrandr --output eDP-1 --off --output HDMI-1 --mode 720x400 --pos 0x0 --rotate normal"
    # "xrandr --output eDP-1 --off --output HDMI-1 --mode 1280x720 --pos 0x0 --rotate normal"
    # "xrandr --output eDP-1 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal"
    # "xrandr --output eDP-1 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate left"
    # "xrandr --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --rate 144 --output HDMI-A-0 --mode 1280x720 --pos 0x0 --rotate normal"
    # "xrandr \
    #     --output HDMI-A-0 --mode 1280x720 --pos 0x0 --rotate normal \
    #     --output DisplayPort-0 --primary --mode 1920x1080 --pos 1280x0 --rotate normal --rate 144"
    # "xrandr \
    #     --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal \
    #     --output DisplayPort-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --rate 144"
    "xrandr \
        --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal \
        --output DisplayPort-0 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --rate 144"
    "xrandr --output DisplayPort-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --rate 144 --output HDMI-A-0 --off"

)

# File to store current layout index
state_file="$HOME/.xrandr-layout-index"

# Read last index, default to -1 (so first run starts at 0)
if [[ -f "$state_file" ]]; then
    index=$(<"$state_file")
else
    index=-1
fi

# Next index
index=$(( (index + 1) % ${#layouts[@]} ))

# Apply layout
eval "${layouts[$index]}"

# Save index
echo "$index" > "$state_file"

