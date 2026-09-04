#!/bin/bash

CURRENT_HOUR=$(date '+%H')
#echo $CURRENT_HOUR

WALLPAPER_DIR="wall"
DISTRIBUTED_DIR="dist"
if ["$CURRENT_HOUR" -gt 8] && ["$CURRENT_HOUR" -lt 13]; then
    WALLPAPER_DIR = $DISTRIBUTED_DIR
fi
echo "$WALLPAPER_DIR"

