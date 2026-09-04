#!/bin/bash

xdotool key Super+braceright
sleep 1
xdotool key Super+y
sleep 0.1
xdotool key Down
xdotool key Super+n
sleep 0.1
xdotool key space

sleep 0.3
for i in {1..19}
do
  sleep 0.3
  xdotool key Up
  xdotool key Super+n
  xdotool key Down
  xdotool key Super+n

done
sleep 0.1
xdotool key Super+u


