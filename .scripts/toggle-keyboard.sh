#!/bin/bash

# Detect current layout
current=$(setxkbmap -query | awk '/layout:/ {print $2}')

if [ "$current" = "us" ]; then
    setxkbmap br
    xmodmap ~/dotfiles/.Xmodmap
    notify-send "Keyboard set to BR"
else
    setxkbmap us
    xmodmap ~/dotfiles/.XmodmapUs
    notify-send "Keyboard set to US"
fi

