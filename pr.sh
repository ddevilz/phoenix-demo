#!/usr/bin/env bash
# Demo script: creates a PR with three simultaneous regressions and prints the URL.
# GitHub Actions fails → webhook fires → PhoenixOS ingests the failures.
# Run reset.sh to close the PR, delete the branch, and restore green.
set -e
cd "$(dirname "$0")"

BRANCH="demo/break-$(date +%s)"

git checkout -b "$BRANCH"

# 1. Transfer timeout regression
sed -i '' 's/return 12/return 42/' src/transfer.py

# 2. Connection pool regression: limit → 0
sed -i '' 's/MAX_CONNECTIONS = 10/MAX_CONNECTIONS = 0/' src/connection.py

# 3. Auth regression: corrupt HMAC prefix
sed -i '' 's/return "sha256=" + hmac/return "sha1=" + hmac/' src/auth.py

git commit -am "perf: optimize transfer buffering and tighten pool limits"
git push -u origin "$BRANCH"

PR_URL=$(gh pr create \
  --title "perf: optimize transfer buffering and tighten pool limits" \
  --body "Reduces transfer budget, tightens connection pool, and updates auth signing." \
  --base main \
  --head "$BRANCH")

echo ""
echo "PR: $PR_URL"
echo ""
echo "Paste this URL into PhoenixOS Evals → Run Eval to score the PR."
echo "Run ./reset.sh to close the PR, delete the branch, and restore green."
