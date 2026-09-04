#!/bin/bash

CATEGORIES=(
    "programming"
    "workflow"
    "housework"
    "wasted"
    "jessica"
    "stop"
    )

selected=$(printf "%s\n" "${CATEGORIES[@]}" | dmenu -i -p "Category: ")

if [[ $selected == "STOP" ]]; then
    timew stop
    tmux set -g status-left "#[fg=#2A2F41,bg=#7aa2f7,bold] #{?client_prefix,󰠠 ,#[dim]󰤂 }#[bold,nodim]#S#($HOME/.tmux/plugins/tokyo-night-tmux/src/hostname-widget.sh)  "
else
    timew start "$selected"
    tmux set -g status-left "#[fg=#2A2F41,bg=#7aa2f7,bold] #{?client_prefix,󰠠 ,#[dim]󰤂 }#[bold,nodim]#S#($HOME/.tmux/plugins/tokyo-night-tmux/src/hostname-widget.sh)  | $selected "
fi
