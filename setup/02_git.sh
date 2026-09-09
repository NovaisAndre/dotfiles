#!/usr/bin/env bash
# Git identity + SSH key (used to clone/push private repos).
set -euo pipefail

EMAIL="novaisandre.dev@gmail.com"
NAME="Andre Novais"

git config --global user.email "$EMAIL" 2>/dev/null || true
git config --global user.name "$NAME" 2>/dev/null || true

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -C "$EMAIL" -N "" -f "$HOME/.ssh/id_ed25519"
fi

if [[ ! -f "$HOME/.ssh/config" ]]; then
  printf 'Host github.com\n\tServerAliveInterval 60\n' > "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
fi

echo "Your public SSH key (add it at GitHub > Settings > SSH keys):"
echo "----------------------------------------------------------------"
cat "$HOME/.ssh/id_ed25519.pub"
echo "----------------------------------------------------------------"
if ! ssh -o BatchMode=yes -T git@github.com >/dev/null 2>&1; then
  echo "SSH to GitHub not working yet — run:  ssh -T git@github.com"
fi