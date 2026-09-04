#!/bin/bash

# Use maim to select an area and save it to a temporary file
maim -s /tmp/screenshot.png

# Use xclip to copy the image to the clipboard
xclip -selection clipboard -t image/png -i /tmp/screenshot.png

# Optional: Remove the temporary file
# rm /tmp/screenshot.png

