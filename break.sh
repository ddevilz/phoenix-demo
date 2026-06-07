#!/usr/bin/env bash
# Run LIVE during the demo: introduces regressions across transfer + connection layers.
# GitHub Actions will fail → webhook fires → PhoenixOS ingests the failures.
set -e
cd "$(dirname "$0")"

# 1. Transfer timeout regression: push elapsed past the 30s budget
sed -i '' 's/return 12/return 42/' src/transfer.py

# 2. Connection pool regression: set max to 0 — all acquire() calls will throw
sed -i '' 's/MAX_CONNECTIONS = 10/MAX_CONNECTIONS = 0/' src/connection.py

# 3. Auth regression: corrupt the prefix so signature verification fails
sed -i '' 's/return "sha256=" + hmac/return "sha1=" + hmac/' src/auth.py

git commit -am "perf: optimize transfer buffering and tighten pool limits"
git push
echo "✅ Pushed breaking change. Switch to the PhoenixOS dashboard and watch the Live Feed."
