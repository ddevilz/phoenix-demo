#!/usr/bin/env bash
# Restore the repo to green so you can re-run the demo.
set -e
cd "$(dirname "$0")"
sed -i '' 's/return 42/return 12/' src/transfer.py
git commit -am "revert transfer buffering change" || { echo "already green"; exit 0; }
git push
echo "✅ Back to green."
