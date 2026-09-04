#!/bin/bash

xdotool key Super+braceright
fibo1=0.001
fibo2=0.002
sleep 1
xdotool key Super+y
sleep 0.1
for i in {1..20}
do
  xdotool key Down
  xdotool key Super+n
  # sleep $fibo1 
  sleep 0.1
  xdotool key Up
  xdotool key Super+n
  fibo_new=$(echo "$fibo1 + $fibo2" | bc -l)

  fibo1=$fibo2
  fibo2=$fibo_new

  echo "fibo1: $fibo1"
  echo "fibo2: $fibo2"
done
sleep 0.1
xdotool key Super+u
xdotool key Super+n


