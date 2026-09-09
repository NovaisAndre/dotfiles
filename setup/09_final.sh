#!/usr/bin/env bash
# Final: default shell, cron, login-time sync.
set -euo pipefail

# --- default shell -> zsh ---
if command -v zsh >/dev/null 2>&1 \
   && [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)" || echo "warn: could not set default shell (needs password)"
fi

# --- cron: hourly repo sync + redshift ---
SYNC_DIR="$HOME/personal/projects/dotfiles/.scripts"
mkdir -p "$HOME/.cache"

cron_lines=(
  "0 * * * * $SYNC_DIR/git-sync.sh $HOME/personal/projects/dotfiles >>$HOME/.cache/git-sync.dotfiles.log 2>&1"
  "0 * * * * $SYNC_DIR/git-sync.sh $HOME/personal/projects/dwm >>$HOME/.cache/git-sync.dwm.log 2>&1"
  "5 * * * * $SYNC_DIR/git-sync.sh $HOME/personal/projects/notes >>$HOME/.cache/git-sync.notes.log 2>&1"
  "1 * * * * $SYNC_DIR/git-sync.sh $HOME/personal/projects/dotfiles-personal >>$HOME/.cache/git-sync.personal.log 2>&1"
  "0 18 * * * DISPLAY=:0 redshift -O 4200"
  "0 7  * * * DISPLAY=:0 redshift -x"
)

{
  crontab -l 2>/dev/null | rg -v 'git-sync\.sh|redshift -O 4200|redshift -x' || true
  printf '%s\n' "${cron_lines[@]}"
} > /tmp/dotfiles.cron
crontab /tmp/dotfiles.cron
rm -f /tmp/dotfiles.cron

# --- login-time sync (via dwm autostart; private repos only if present) ---
autostart="$HOME/personal/projects/dwm/autostart.sh"
marker='# --- auto sync (managed by dotfiles setup) ---'
if [[ -f "$autostart" ]] && ! rg -q "$marker" "$autostart"; then
  cat >> "$autostart" <<EOF

$marker
"$SYNC_DIR/git-sync-all.sh" >>"\$HOME/.cache/git-sync.log" 2>&1 &
EOF
fi

echo "Final steps done."