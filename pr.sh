#!/usr/bin/env bash
# Creates a branch + PR with regressions and prints the PR URL.
# GitHub Actions fails → webhook fires → PhoenixOS ingests failures.
# Run reset.sh to close the PR, delete the branch, and restore green.
set -e
cd "$(dirname "$0")"
source lib/regressions.sh

BRANCH="demo/break-$(date +%s)"
git checkout -b "$BRANCH"

apply_regressions
git commit -am "$REGRESSIONS_COMMIT_MSG"
git push -u origin "$BRANCH"

PR_URL=$(gh pr create \
  --title "$REGRESSIONS_PR_TITLE" \
  --body "$REGRESSIONS_PR_BODY" \
  --base main \
  --head "$BRANCH")

echo ""
echo "PR: $PR_URL"
echo ""
echo "Paste this URL into PhoenixOS Evals → Run Eval to score the PR."
echo "Run ./reset.sh to close the PR, delete the branch, and restore green."
