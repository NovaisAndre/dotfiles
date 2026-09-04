#!/usr/bin/env bash
# Per-host settings driven by setup/hosts.conf (keyboard, touchpad, timezone).
set -euo pipefail

conf="$REPO/setup/hosts.conf"
layout=""
xmod=""

while IFS=$'\t' read -r host l xm; do
  case "$host" in ''|\#*) continue ;; esac
  if [[ "$host" == "$HOSTNAME" ]]; then
    layout="$l"
    xmod="$xm"
    break
  fi
done < "$conf"

if [[ -n "$layout" ]]; then
  setxkbmap "$layout" 2>/dev/null || true
  if [[ -n "$xmod" && -f "$REPO/$xmod" ]]; then
    xmodmap "$REPO/$xmod" 2>/dev/null || true
  fi
  echo "Keyboard: host='$HOSTNAME' layout='$layout' xmodmap='$xmod'"
else
  echo "No entry in $conf for hostname '$HOSTNAME'. Add one, e.g.:"
  echo "  $HOSTNAME	br	.Xmodmap"
fi

# tap-to-click for the touchpad (Xorg drop-in)
if [[ -f "$REPO/40-libinput.conf" ]]; then
  sudo install -m 0644 "$REPO/40-libinput.conf" /etc/X11/xorg.conf.d/40-libinput.conf
fi

# timezone
sudo timedatectl set-timezone America/Fortaleza 2>/dev/null || true

echo "Per-host config applied."