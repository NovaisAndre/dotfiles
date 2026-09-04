#!/usr/bin/env bash
# GNU stow: link the repo into $HOME.
# Pre-existing real files/dirs that would conflict are backed up first.
set -euo pipefail

command -v stow >/dev/null 2>&1 || sudo apt install -y stow

cd "$REPO"

# Back up anything in $HOME that would collide with the stow links.
handle() {
  local base="$1" target="$HOME/$1"
  [[ -e "$target" || -L "$target" ]] || return 0
  [[ -L "$target" ]] && return 0          # already a symlink (previous stow)
  mv "$target" "$target.setup-backup"
  echo "backed up ~/$base -> ~/$base.setup-backup"
}

for base in "$REPO"/.* "$REPO"/*; do
  name="$(basename "$base")"
  [[ "$name" == "." || "$name" == ".." || "$name" == ".git" ]] && continue
  handle "$name"
done

stow --target="$HOME" --verbose=1 .

echo "Dotfiles stowed into $HOME."