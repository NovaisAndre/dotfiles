#!/bin/bash

DEVICE_NAME=$(pactl list cards short | awk '/bluez_card/ {print $2; exit}')

if [ -z "$DEVICE_NAME" ]; then
    notify-send "Bluetooth Profile" "No Bluetooth audio device found."
    exit 1
fi

CURRENT_PROFILE=$(pactl list cards | grep -A 30 "$DEVICE_NAME" | grep "Active Profile" | awk -F": " '{print $2}' | xargs)

echo "Current profile: $CURRENT_PROFILE"

set_profile_if_exists() {
    PROFILE="$1"
    if pactl set-card-profile "$DEVICE_NAME" "$PROFILE" 2>/dev/null; then
        notify-send "Bluetooth Profile" "Switched to $PROFILE"
        return 0
    fi
    return 1
}

switch_to_a2dp() {
    set_profile_if_exists "a2dp_sink" || \
    set_profile_if_exists "a2dp-sink-sbc_xq" || \
    set_profile_if_exists "a2dp-sink"
}

switch_to_hfp() {
    set_profile_if_exists "handsfree_head_unit" || \
    set_profile_if_exists "headset_head_unit" || \
    set_profile_if_exists "headset-head-unit"
}

if [[ "$CURRENT_PROFILE" == a2dp* ]]; then
    switch_to_hfp
else
    switch_to_a2dp
fi
