#!/usr/bin/env bash
# Repositories: dwm (+ notes and dotfiles-personal when --personal).
set -euo pipefail

mkdir -p "$HOME/personal/projects" "$HOME/work"

clone_or_update() {
  local url="$1" dir="$2"
  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" pull --rebase --autostash || true
  else
    git clone "$url" "$dir"
  fi
}

# public repos: HTTPS clone, no credentials needed
clone_or_update "https://github.com/NovaisAndre/dwm.git" "$HOME/personal/projects/dwm"

if [[ "$PERSONAL" == 1 ]]; then
  clone_or_update "git@github.com:NovaisAndre/notes.git" "$HOME/personal/projects/notes"
  clone_or_update "git@github.com:NovaisAndre/dotfiles-personal.git" "$HOME/personal/projects/dotfiles-personal"
  "$HOME/personal/projects/dotfiles-personal/setup.sh"
fi

echo "Repositories ready."