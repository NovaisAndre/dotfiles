#!/usr/bin/env bash

set -u

MUSIC_DIR="$HOME/Music/youtube/rocket-league"
TIME_LIMIT=3600  # 20 minutes

# Start BakkesHelper
/usr/bin/BakkesHelper &

# Start music (shuffle, loop)
mpv \
  --no-video \
  --shuffle \
  --loop-playlist \
  "$MUSIC_DIR" \
  >/dev/null 2>&1 &

MPV_PID=$!

# Kill Rocket League after time limit
(
  sleep "$TIME_LIMIT"
  pkill -f RocketLeague.exe
) &

# Launch Rocket League (Steam passes it here)
"$@"
RL_EXIT_CODE=$?

# When Rocket League exits, stop music
kill "$MPV_PID" 2>/dev/null || true

exit "$RL_EXIT_CODE"
