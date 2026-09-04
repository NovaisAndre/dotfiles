#!/usr/bin/env bash
# Aggressive Battery Saver / Performance Toggle for Ubuntu + dwm
# Author: André (optimized for minimal setups)
# License: MIT

set -euo pipefail

# Helper for colored output
info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
ok()   { echo -e "\033[1;32m[OK]\033[0m $*"; }

# Detect power source automatically unless specified
MODE="${1:-auto}"

detect_power() {
  if [[ "$MODE" == "battery" ]]; then
    echo "battery"
  elif [[ "$MODE" == "performance" ]]; then
    echo "performance"
  else
    # auto-detect: look for AC power state
    if [[ -f /sys/class/power_supply/AC/online ]] && grep -q 1 /sys/class/power_supply/AC/online; then
      echo "performance"
    elif [[ -f /sys/class/power_supply/ACAD/online ]] && grep -q 1 /sys/class/power_supply/ACAD/online; then
      echo "performance"
    else
      echo "battery"
    fi
  fi
}

POWER_MODE=$(detect_power)

if [[ "$POWER_MODE" == "battery" ]]; then
  info "Switching to BATTERY SAVER mode ⚡"

  # Lower screen brightness
  brightnessctl set 21% || warn "brightnessctl not available"

  # Disable Wi-Fi and Bluetooth
  # sudo rfkill block bluetooth || warn "Failed to block Bluetooth"
  # sudo nmcli radio wifi off || warn "Failed to disable Wi-Fi"

  # CPU governor: powersave
  if command -v cpufreq-set >/dev/null 2>&1; then
    sudo cpufreq-set -g powersave || warn "Failed to set CPU governor"
  fi

  # Start TLP
  sudo systemctl start tlp || warn "Failed to start TLP"

  # Reduce USB autosuspend delay
  for dev in /sys/bus/usb/devices/usb*/power/autosuspend_delay_ms; do
    echo '0' | sudo tee "$dev" >/dev/null 2>&1 || true
  done

  ok "Battery Saver mode activated ✅"

else
  info "Switching to PERFORMANCE mode ⚙️"

  # Restore screen brightness
  sudo brightnessctl set 100% || warn "brightnessctl not available"

  # Enable Wi-Fi and Bluetooth
  sudo rfkill unblock bluetooth || warn "Failed to unblock Bluetooth"
  sudo nmcli radio wifi on || warn "Failed to enable Wi-Fi"

  # CPU governor: performance
  if command -v cpufreq-set >/dev/null 2>&1; then
    sudo cpufreq-set -g performance || warn "Failed to set CPU governor"
  fi

  # Stop TLP (if you want max performance)
  sudo systemctl stop tlp || warn "Failed to stop TLP"

  # Reset USB autosuspend to default (2000 ms)
  for dev in /sys/bus/usb/devices/usb*/power/autosuspend_delay_ms; do
    echo '2000' | sudo tee "$dev" >/dev/null 2>&1 || true
  done

  ok "Performance mode restored ⚡"
fi

