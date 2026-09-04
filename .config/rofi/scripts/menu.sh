#!/usr/bin/env bash
# ~/.config/rofi/menu.sh
# Custom Rofi launcher for apps, scripts, and system actions

declare -A actions

# --- Add your programs and scripts here ---
actions["🔋 Battery Saver"]="battery-toggle battery"
actions["⚙️ Performance Mode"]="battery-toggle performance"
actions["💤 Suspend"]="systemctl suspend"
actions["⏻ Power Off"]="systemctl poweroff"
actions["🔄 Reboot"]="systemctl reboot"
# ------------------------------------------

choice=$(printf '%s\n' "${!actions[@]}" | sort | rofi -dmenu -i -p "Run:")

[[ -n "$choice" ]] && ${actions["$choice"]} &

