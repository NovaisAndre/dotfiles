#!/bin/bash

current_volume=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.ncspot /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Volume" | grep double | awk '{print $3}')
new_volume=$(echo "$current_volume - 0.05" | bc)
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.ncspot /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:"org.mpris.MediaPlayer2.Player" string:"Volume" variant:double:$new_volume

