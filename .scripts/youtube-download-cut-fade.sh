#!/usr/bin/env bash
set -Eeuo pipefail

# --- CONFIG ---
MUSIC_DIR="$HOME/Music/youtube"
TARGET_BASE="$HOME/.sounds"

mkdir -p "$MUSIC_DIR"

# --- STEP 1: Copy URL from browser ---
sleep_time=0.2
xdotool key Super+braceright
sleep $sleep_time
xdotool key ctrl+l
sleep $sleep_time
xdotool key ctrl+a
sleep $sleep_time
xdotool key ctrl+c
sleep $sleep_time

url=$(xclip -o -selection clipboard 2>/dev/null || true)
if [[ -z "${url:-}" ]]; then
  notify-send "Error" "Clipboard is empty."
  exit 1
fi

clean_url=$(echo "$url" | sed -E 's#(https?://)?(www\.youtube\.com/watch\?v=[^&]+).*#https://\2#')

notify-send "Downloading" "$clean_url"

# --- STEP 2: Download and extract MP3 ---
file_path=$(yt-dlp -x --audio-format mp3 -o "$MUSIC_DIR/%(title)s.%(ext)s" --print after_move:filepath "$clean_url" 2>/dev/null)

if [[ -z "${file_path:-}" ]]; then
  notify-send "Error" "yt-dlp did not return a file path."
  exit 1
fi

# Sanitize filename
safe_filename=$(basename "$file_path" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')
dir=$(dirname "$file_path")
input="$dir/$safe_filename.mp3"
mv "$file_path" "$input"

notify-send "Downloaded" "$safe_filename.mp3"

# --- STEP 3: Gather user input via rofi ---
rofi_prompt() {
  local prompt="$1"
  local input
  input=$(rofi -dmenu -p "$prompt" -theme-str 'entry { placeholder: " "; }' || true)
  echo "$input"
}

output_name=$(rofi_prompt "Output filename (no extension):")
[[ -z "$output_name" ]] && notify-send "Cancelled" && exit 0

subdir=$(rofi_prompt "Destination subdir (under assets/):")
[[ -z "$subdir" ]] && notify-send "Cancelled" && exit 0

cut_start=$(rofi_prompt "Cut start (e.g. 00:00:30, leave empty for 00:00:00):")
cut_end=$(rofi_prompt "Cut end (e.g. 00:01:00, leave empty for full length):")

# --- STEP 4: Prepare destination ---
dest_dir="$TARGET_BASE/$subdir"
mkdir -p "$dest_dir"
output="$dest_dir/${output_name}.mp3"

# --- STEP 5: Convert HH:MM:SS to seconds (if provided) ---
to_seconds() {
  IFS=':' read -r -a parts <<< "$1"
  if [ ${#parts[@]} -eq 3 ]; then
    awk "BEGIN {print (${parts[0]}*3600)+(${parts[1]}*60)+${parts[2]}}"
  elif [ ${#parts[@]} -eq 2 ]; then
    awk "BEGIN {print (${parts[0]}*60)+${parts[1]}}"
  elif [ -n "$1" ]; then
    echo "$1"
  else
    echo ""
  fi
}

start_sec=$(to_seconds "$cut_start")
end_sec=$(to_seconds "$cut_end")

# --- STEP 6: Build ffmpeg command dynamically ---
if [[ -n "$end_sec" ]]; then
  duration=$(awk "BEGIN {print $end_sec - ${start_sec:-0}}")
  if (( $(echo "$duration <= 0" | bc -l) )); then
    notify-send "Error" "End time must be after start time."
    exit 1
  fi
  fade_out_start=$(awk "BEGIN {print $duration - 1}")
  ffmpeg -y -i "$input" ${start_sec:+-ss "$start_sec"} -t "$duration" \
    -af "afade=t=in:ss=0:d=1,afade=t=out:st=$fade_out_start:d=1" \
    "$output" >/dev/null 2>&1
else
  # No end time → keep entire audio, apply only fade-in/out based on full duration
  ffmpeg -y -i "$input" ${start_sec:+-ss "$start_sec"} \
    -af "afade=t=in:ss=0:d=1,afade=t=out:st=9999:d=1" \
    "$output" >/dev/null 2>&1
fi

notify-send "✅ Done" "Saved to: $output"
echo "✅ Output saved to: $output"

