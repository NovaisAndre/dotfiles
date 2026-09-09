#!/usr/bin/env bash
# tmux: TPM + plugins.
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

"$TPM_DIR/bin/install_plugins" || true
tmux source ~/.tmux.conf 2>/dev/null || true

echo "tmux ready."