#!/usr/bin/env bash

set -e

sleep 1

# Coordinates
FIGHTCADE_TRAINNING_X=1178
FIGHTCADE_TRAINNING_Y=63
GAME_X=23
GAME_Y=9
BROWSE_X=55
BROWSE_Y=88
ROMS_X=537
ROMS_Y=225
RUN_X=1235
RUN_Y=81

click() {
    xdotool mousemove "$1" "$2" click 1
}

key() {
    xdotool key "$@"
}

# Go to the Fightcade workspace
key Super+ampersand
sleep 0.5

# Open training
click "$FIGHTCADE_TRAINNING_X" "$FIGHTCADE_TRAINNING_Y"
sleep 5

# Configure game
click "$GAME_X" "$GAME_Y"
sleep 0.5

key Down
key Down
key Right
key Down
key Return

sleep 1

# Browse ROMs
click "$BROWSE_X" "$BROWSE_Y"
sleep 1

click "$ROMS_X" "$ROMS_Y"

key Return

for _ in {1..6}; do
    key Down
done

key Return

sleep 1

# Run game
click "$RUN_X" "$RUN_Y"

sleep 5

# Return to notebook workspace
key Super+n

sleep 1

# Fullscreen emulator
key Alt+Return
