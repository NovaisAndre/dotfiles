#!/usr/bin/env bash
# dwm: build deps, compile+install, LightDM autologin + session.
set -euo pipefail

sudo apt install -y \
  xorg xinit lightdm \
  libx11-dev libxinerama-dev libxft-dev libx11-xcb-dev libxcb-res0-dev \
  libxcb1-dev libxcb-util0-dev libxrandr-dev

if [[ ! -x /usr/local/bin/dwm ]]; then
  sudo make -C "$HOME/personal/projects/dwm" clean install
fi

# X session file (fixes the old Encoding=UTF-] typo)
cat > /tmp/dwm.desktop <<'EOF'
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=dwm
Icon=dwm
Type=XSession
EOF
sudo install -m 0644 /tmp/dwm.desktop /usr/share/xsessions/dwm.desktop
rm -f /tmp/dwm.desktop

# LightDM: autologin into dwm
sudo mkdir -p /etc/lightdm
printf '[Seat:*]\nautologin-user=%s\nuser-session=dwm\n' "$USER" \
  | sudo tee /etc/lightdm/lightdm.conf >/dev/null

echo "dwm installed; LightDM will autologin $USER into dwm."