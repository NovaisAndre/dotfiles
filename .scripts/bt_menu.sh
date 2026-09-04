#!/bin/bash

# Get list of known Bluetooth devices
devices=$(bluetoothctl devices)

if [ -z "$devices" ]; then
    notify-send "Bluetooth" "No devices found"
    exit 1
fi

# Build dmenu prompt: list of device names
selection=$(echo "$devices" | awk '{$1=""; print substr($0,2)}' | dmenu -i -p "Bluetooth Device:")

# Get MAC address based on selected name
mac=$(echo "$devices" | grep "$selection" | awk '{print $2}')

# If nothing was selected, exit
[ -z "$mac" ] && exit

# Check current connection state
connected=$(bluetoothctl info "$mac" | grep "Connected: yes")

# Toggle connection
if [ -n "$connected" ]; then
    bluetoothctl disconnect "$mac" && notify-send "Bluetooth" "Disconnected: $selection"
else
    bluetoothctl connect "$mac" && notify-send "Bluetooth" "Connected: $selection"

    # Wait a bit for PulseAudio/PipeWire to register the device
    sleep 2

    # Normalize MAC (replace : with _ and lowercase) to match sink names
    mac_normalized=$(echo "$mac" | tr '[:upper:]' '[:lower:]' | sed 's/:/_/g')

    for i in {1..5}; do
        sink=$(pactl list short sinks | grep -i "$mac_normalized" | awk '{print $2}')
        [ -n "$sink" ] && break
        sleep 1
    done

    if [ -n "$sink" ]; then
        pactl set-default-sink "$sink"
        notify-send "Bluetooth" "Audio routed to: $selection"
    else
        # Fallback: grab the *last* sink (new devices usually appear last)
        sink=$(pactl list short sinks | tail -n1 | awk '{print $2}')
        if [ -n "$sink" ]; then
            pactl set-default-sink "$sink"
            notify-send "Bluetooth" "Audio routed to (fallback): $selection"
        else
            notify-send "Bluetooth" "Connected but no sink found for: $selection"
        fi
    fi
fi

