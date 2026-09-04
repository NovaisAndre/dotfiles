#!/bin/bash

text=$(tmux capture-pane -pS -)
# echo $text
# xdotool key Super+braceright 
if [[ "$text" == *"2b"* ]]; then
    tmux resize-pane -Z
    tmux new-window -t fastterm -n icat "ascii-image-converter ~/.wallpapers/twobe.png && sleep 0.25"
    sleep 1
    feh --bg-max ~/.wallpapers/twobe.png
fi
if [[ "$text" == *"8001"* ]]; then
    tmux resize-pane -Z
    tmux new-window -t fastterm -n icat "\
        ascii-image-converter ~/.wallpapers/vegeta.png && \
        sleep 0.25 \
        "
    sleep 1
    feh --bg-max ~/.wallpapers/vegeta.png 
    mpv ~/Music/youtube/pokémon-diamond-and-pearl-cynthia-battle-theme-remix-mp3 &
    sleep 10
    pkill mpv
fi
