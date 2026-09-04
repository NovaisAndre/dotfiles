#!/usr/bin/env bash
set -euo pipefail

# Usage: ./audio_cut_fade.sh input.mp3 00:01:30 00:02:00
# Cuts from 1:30 to 2:00, adds fade in/out, and saves as input-cut.mp3

if [ $# -ne 3 ]; then
  echo "Usage: $0 <input_file> <cut_start> <cut_end>"
  exit 1
fi

input="$1"
cut_start="$2"
cut_end="$3"

# Function to convert HH:MM:SS or MM:SS or SS to seconds (float-safe)
to_seconds() {
  IFS=':' read -r -a parts <<< "$1"
  if [ ${#parts[@]} -eq 3 ]; then
    awk "BEGIN {print (${parts[0]}*3600) + (${parts[1]}*60) + ${parts[2]}}"
  elif [ ${#parts[@]} -eq 2 ]; then
    awk "BEGIN {print (${parts[0]}*60) + ${parts[1]}}"
  else
    echo "$1"
  fi
}

start_sec=$(to_seconds "$cut_start")
end_sec=$(to_seconds "$cut_end")
duration=$(awk "BEGIN {print $end_sec - $start_sec}")

if (( $(echo "$duration <= 0" | bc -l) )); then
  echo "Error: cut_end must be greater than cut_start"
  exit 1
fi

base="${input%.*}"
output="${base}-cut.mp3"

# Apply trim and fades
ffmpeg -y -i "$input" -ss "$start_sec" -t "$duration" \
  -af "afade=t=in:ss=0:d=1,afade=t=out:st=$(awk "BEGIN {print $duration - 1}") :d=1" \
  "$output"

echo "✅ Output saved to: $output"

