#!/usr/bin/env bash
# System packages: apt, snap, yt-dlp
set -euo pipefail

APT_PACKAGES=(
  stow git i3 rofi kitty tmux zoxide llvm clang fzf zsh picom feh gcc firefox
  dmenu arandr ripgrep brightnessctl bc coreutils gawk jq playerctl dunst mpv
  flatpak xclip maim vlc libnotify-bin xdotool pandoc build-essential curl wget unzip
)
SNAP_PACKAGES=(discord telegram-desktop spotify)

sudo apt update
sudo apt upgrade -y
sudo apt install -y "${APT_PACKAGES[@]}"

for pkg in "${SNAP_PACKAGES[@]}"; do
  sudo snap install "$pkg" 2>/dev/null || true
done

if [[ ! -f /usr/local/bin/yt-dlp ]]; then
  sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    -o /usr/local/bin/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp
fi

echo "Packages installed."