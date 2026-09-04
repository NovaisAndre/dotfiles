#!/bin/bash

# Use fzf to search through the cleaned-up Zsh history
selected=$(cat ~/.zsh_history | sed -E 's/^: [0-9]+:[0-9]+;//' | fzf --height=20% --reverse --prompt="Search history: ")

# If a command is selected, pass it to dmenu
if [ -n "$selected" ]; then
    final_command=$(echo "$selected" | dmenu -i -p "Edit or confirm command:")

    # If a command is confirmed in dmenu, type it on the command line
    if [ -n "$final_command" ]; then
        # Simulate typing the command on the current terminal
        printf "%s" "$final_command" > "$(tty)"
    fi
else
    echo "No command selected."
fi

