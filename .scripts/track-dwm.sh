#!/bin/bash

LOGFILE="$HOME/dwm_workspace_log.txt"
LAST_WIN_ID=$(xdotool getwindowfocus)
START_TIME=$(date +%s)

echo "Tracking started at $(date)" >> "$LOGFILE"

while true; do
    CURRENT_WIN_ID=$(xdotool getwindowfocus)
    
    if [[ "$CURRENT_WIN_ID" != "$LAST_WIN_ID" ]]; then
        END_TIME=$(date +%s)
        DURATION=$((END_TIME - START_TIME))
        WINDOW_NAME=$(xdotool getwindowname "$LAST_WIN_ID" 2>/dev/null)
        
        if [[ -n "$WINDOW_NAME" ]]; then
            echo "Window: $WINDOW_NAME | Time: ${DURATION}s" >> "$LOGFILE"
        fi

        # Update values for next iteration
        LAST_WIN_ID="$CURRENT_WIN_ID"
        START_TIME="$END_TIME"
    fi
    
    sleep 2
done

