#!/usr/bin/env bash
# Bootstrap / maintenance orchestrator for this dotfiles repo.
#
# Usage:
#   ./setup.sh               full public setup (packages, git, stow, dwm, per-host, nvim, tmux, final)
#   ./setup.sh --personal    also clone private repos (notes, dotfiles-personal) + link assets
#   ./setup.sh --only NN     run a single step (e.g. --only 04)
#   ./setup.sh --list        list available steps
#
# Every step is idempotent and safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REPO

PERSONAL=0
ONLY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --personal) PERSONAL=1 ;;
    --only) ONLY="${2:-}"; shift ;;
    --list)
      ls "$REPO"/setup/[0-9][0-9]_*.sh | sed 's|.*/||; s|\.sh$||'
      exit 0
      ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
  shift
done

export PERSONAL

steps=(
  01_packages
  02_git
  03_repos
  04_stow
  05_dwm
  06_perhost
  07_neovim
  08_tmux
  09_final
)

logdir="${TMPDIR:-/tmp}/dotfiles-setup"
mkdir -p "$logdir"

for step in "${steps[@]}"; do
  if [[ -n "$ONLY" && "$ONLY" != "$step" ]]; then
    continue
  fi
  label="$(tr '_' ' ' <<<"$step")"
  echo ">>> [$step] $label"
  "$REPO/setup/${step}.sh" | tee "$logdir/${step}.log"
  echo "<<< done ($step)"
done

echo
echo "Setup finished. Steps log: $logdir"
echo "Next: log out and back in (LightDM should start dwm)."