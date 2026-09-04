#/usr/bin/env bash

set -u  # error on unset variables

mkdir -p "$HOME/Music/youtube"

sleep_time=0.2

# Grab current browser URL
xdotool key Super+braceright
sleep "$sleep_time"
xdotool key ctrl+l
sleep "$sleep_time"
xdotool key ctrl+a
sleep "$sleep_time"
xdotool key ctrl+c
sleep "$sleep_time"

url=$(xclip -o -selection clipboard)

# Normalize YouTube URL
clean_url=$(echo "$url" | sed -E 's#(https?://)?(www\.youtube\.com/watch\?v=[^&]+).*#https://\2#')

if [[ -z "$clean_url" ]]; then
  notify-send "YouTube Download Failed" "Could not detect URL" &
  exit 1
fi

echo "Downloading: $clean_url"
notify-send "Downloading" "$clean_url" &

download() {
  yt-dlp -x \
    --audio-format mp3 \
    -o "$HOME/Music/youtube/%(title)s.%(ext)s" \
    --print after_move:filepath \
    "$clean_url"
}

# First attempt
file_path=$(download)
status=$?

# If failed → update and retry once
if [[ $status -ne 0 ]]; then
  notify-send "yt-dlp failed. Updating..." &
  yt-dlp -U

  file_path=$(download)
  status=$?
fi

# Final failure check
if [[ $status -ne 0 || -z "$file_path" ]]; then
  notify-send "YouTube Download Failed" "Check terminal output" &
  exit 1
fi

# Generate safe filename (preserve extension)
base=$(basename "$file_path")
ext="${base##*.}"
name="${base%.*}"
safe_name=$(echo "$name" | \
  tr '[:upper:]' '[:lower:]' | \
  sed -E 's/[^a-z0-9]+/-/g' | \
  sed -E 's/^-+|-+$//g')
safe_filename="$safe_name.$ext"

dir=$(dirname "$file_path")
new_path="$dir/$safe_filename"

mv -- "$file_path" "$new_path"

notify-send "YouTube Download Complete" "Saved as $safe_filename" &
echo "Saved as: $new_path"
