#!/usr/bin/env bash
# Run LIVE during the demo: introduces a transfer timeout regression and pushes.
# GitHub Actions will fail → webhook fires → PhoenixOS ingests the failure.
set -e
cd "$(dirname "$0")"
sed -i '' 's/return 12/return 42/' src/transfer.py
git commit -am "optimize transfer buffering"
git push
echo "✅ Pushed breaking change. Switch to the PhoenixOS dashboard and watch the Live Feed."
