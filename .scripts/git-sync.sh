#!/usr/bin/env bash
# Atomic repo sync: commit local changes, pull --rebase, push.
#
# Usage:
#   git-sync.sh <repo> [branch]
#
# Fixes the old bug: the previous cron scripts only pushed (no pull), so
# the second machine's push was rejected (non-fast-forward) and machines
# never received each other's changes. This script pulls before pushing.
set -euo pipefail

repo="$1"
branch="$2"

cd "$repo"

git config pull.rebase true >/dev/null 2>&1 || true

# 1. Commit everything local (only if something changed)
git add -A
if git diff --cached --quiet; then
  new_commits=no
else
  git commit -m "auto: $(date +'%Y-%m-%d %H:%M:%S') ($(hostname))" >/dev/null
  echo "[git-sync] committed changes in $repo"
fi

# 2. If the remote branch is unknown (first sync of a new repo), push directly.
if ! git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  git push -u origin "$branch"
  exit 0
fi

# 3. Pull remote changes, then push ours.
git pull --autostash origin "$branch" || {
  echo "[git-sync] ERROR: rebase/merge conflict in $repo — resolve manually"
  exit 1
}
git push origin "$branch"

echo "[git-sync] synced $repo ($branch) at $(date +'%H:%M:%S')"