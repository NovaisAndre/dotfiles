#!/bin/bash

# Read current clipboard
text=$(xclip -o -selection clipboard)

# Extract text between the first matching quotes (single or double)
if [[ $text =~ [\'\"]([^\'\"]+)[\'\"] ]]; then
    extracted="${BASH_REMATCH[1]}"
    echo -n "$extracted" | xclip -selection clipboard
    notify-send "Selected between quotes" "$extracted"
else
    notify-send "No quotes found" "$text"
fi

