#!/usr/bin/env bash
# Introduces regressions on main and pushes.
# GitHub Actions fails → webhook fires → PhoenixOS ingests failures.
set -e
cd "$(dirname "$0")"
source lib/regressions.sh

apply_regressions
git commit -am "$REGRESSIONS_COMMIT_MSG"
git push
echo "✅ Pushed breaking change. Switch to the PhoenixOS dashboard and watch the Live Feed."
