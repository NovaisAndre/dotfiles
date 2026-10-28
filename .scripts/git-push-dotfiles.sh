#!/bin/bash

REPO="$HOME/dotfiles"
LOG="$HOME/.local/log/git-push-dotfiles.log"
mkdir -p "$(dirname "$LOG")"

{
  echo "=== $(date) ==="
  cd "$REPO" || { echo "Failed to cd to $REPO"; exit 1; }

  # Ensure we're in a git repo
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not a git repo"; exit 1; }

  # Pull latest changes to avoid conflicts
  git pull --rebase --autostash >/dev/null 2>&1 || true

  # Add changes
  git add . || { echo "git add failed"; exit 1; }

  # Check if there are changes to commit
  if git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
  fi

  git commit -m "Auto commit on $(date +'%Y-%m-%d %H:%M:%S')" || { echo "git commit failed"; exit 1; }
  git push || { echo "git push failed"; exit 1; }

  echo "Success"
} >> "$LOG" 2>&1

# Send notification on failure
if [ $? -ne 0 ]; then
  if command -v notify-send >/dev/null 2>&1; then
    DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus notify-send -u critical "git-push-dotfiles" "Failed to push dotfiles. Check $LOG" 2>/dev/null
  fi
  if command -v wall >/dev/null 2>&1; then
    wall "git-push-dotfiles FAILED - check $LOG" 2>/dev/null
  fi
fi
