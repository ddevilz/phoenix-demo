#!/usr/bin/env bash
# Restore the repo to green so you can re-run the demo.
set -e
cd "$(dirname "$0")"

sed -i '' 's/return 42/return 12/' src/transfer.py
sed -i '' 's/MAX_CONNECTIONS = 0/MAX_CONNECTIONS = 10/' src/connection.py
sed -i '' 's/return "sha1=" + hmac/return "sha256=" + hmac/' src/auth.py

git commit -am "revert: restore transfer, pool, and auth to baseline" || { echo "already green"; exit 0; }
git push
echo "✅ Back to green."
