#!/bin/bash

# Get current default sink
current_sink=$(pactl get-default-sink)

# Get all sinks in an array
sinks=($(pactl list short sinks | awk '{print $2}'))

# Find the index of the current sink
index=-1
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current_sink" ]]; then
        index=$i
        break
    fi
done

# Calculate next index (loop back if at the end)
if [[ $index -ge 0 ]]; then
    next_index=$(( (index + 1) % ${#sinks[@]} ))
    next_sink="${sinks[$next_index]}"
    
    # Set new default sink
    pactl set-default-sink "$next_sink"
    echo "Switched to: $next_sink"

    # Move all currently playing audio streams to the new sink
    mapfile -t inputs < <(pactl list short sink-inputs | awk '{print $1}')
    for input in "${inputs[@]}"; do
        pactl move-sink-input "$input" "$next_sink"
    done

    notify-send "Moved active streams to: $next_sink"
else
    echo "Current sink not found in list!"
fi

