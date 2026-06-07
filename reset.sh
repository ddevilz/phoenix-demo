#!/usr/bin/env bash
# Restore the repo to green. Works after both break.sh (main) and pr.sh (branch).
set -e
cd "$(dirname "$0")"

CURRENT=$(git branch --show-current)

# If on a demo branch: close open PR, switch back to main, delete branch
if [[ "$CURRENT" == demo/* ]]; then
  gh pr close "$CURRENT" --delete-branch 2>/dev/null || true
  git checkout main
  git branch -D "$CURRENT" 2>/dev/null || true
fi

git pull --rebase origin main 2>/dev/null || true

sed -i '' 's/return 42/return 12/' src/transfer.py 2>/dev/null || true
sed -i '' 's/MAX_CONNECTIONS = 0/MAX_CONNECTIONS = 10/' src/connection.py 2>/dev/null || true
sed -i '' 's/return "sha1=" + hmac/return "sha256=" + hmac/' src/auth.py 2>/dev/null || true

git commit -am "revert: restore transfer, pool, and auth to baseline" 2>/dev/null \
  || { echo "already green"; exit 0; }
git push
echo "✅ Back to green."
