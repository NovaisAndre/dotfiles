#!/bin/bash

sshfile="$HOME/.scripts/ssh-hosts"

if [ ! -s "$sshfile" ]; then
    echo "No SSH hosts found. Please add them to $sshfile."
    exit 1
fi

sshpc=$(cat "$sshfile" | dmenu -i -l 20 -p "Select pc:")

# If an SSH destination is selected, connect using kitty
if [ -n "$sshpc" ]; then
    kitty --detach bash -c "tmux new-session -A -s ssh_session \; send-keys 'ssh $sshpc' C-m"
else
    echo "No PC selected."
fi

