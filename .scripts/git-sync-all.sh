#!/usr/bin/env bash
# Sync all local repos. Public repos always; private repos only if cloned.
# Run at login (via dwm autostart) and by cron. Safe to run offline.
set -u

here="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.cache"

for repo in \
  "$HOME/personal/projects/dotfiles" \
  "$HOME/personal/projects/dwm" \
  "$HOME/personal/projects/notes" \
  "$HOME/personal/projects/dotfiles-personal"; do
  [[ -d "$repo/.git" ]] || continue
  "$here/git-sync.sh" "$repo" >>"$HOME/.cache/git-sync.log" 2>&1 || true
done