#!/usr/bin/env bash
# Restores repo to green. Works after both break.sh (main) and pr.sh (branch).
set -e
cd "$(dirname "$0")"
source lib/regressions.sh

CURRENT=$(git branch --show-current)

# If on a demo branch: close open PR, switch back to main, delete branch
if [[ "$CURRENT" == demo/* ]]; then
  gh pr close "$CURRENT" --delete-branch 2>/dev/null || true
  git checkout main
  git branch -D "$CURRENT" 2>/dev/null || true
fi

git pull --rebase origin main 2>/dev/null || true

revert_regressions

git commit -am "revert: restore to baseline" 2>/dev/null \
  || { echo "already green"; exit 0; }
git push
echo "✅ Back to green."
