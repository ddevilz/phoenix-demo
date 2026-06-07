#!/usr/bin/env bash
# Shared regression config. Source this file; call apply_regressions or revert_regressions.
# To add a regression: add a matching sed pair in both functions below.

REGRESSIONS_COMMIT_MSG="perf: optimize transfer buffering and tighten pool limits"
REGRESSIONS_PR_TITLE="perf: optimize transfer buffering and tighten pool limits"
REGRESSIONS_PR_BODY="Reduces transfer budget, tightens connection pool, and updates auth signing."

apply_regressions() {
  # 1. Transfer timeout: push elapsed past the 30s budget
  sed -i '' 's/return 12/return 42/' src/transfer.py

  # 2. Connection pool: set max to 0 — all acquire() calls throw
  sed -i '' 's/MAX_CONNECTIONS = 10/MAX_CONNECTIONS = 0/' src/connection.py

  # 3. Auth signing: corrupt prefix so verification fails
  sed -i '' 's/return "sha256=" + hmac/return "sha1=" + hmac/' src/auth.py
}

revert_regressions() {
  sed -i '' 's/return 42/return 12/' src/transfer.py 2>/dev/null || true
  sed -i '' 's/MAX_CONNECTIONS = 0/MAX_CONNECTIONS = 10/' src/connection.py 2>/dev/null || true
  sed -i '' 's/return "sha1=" + hmac/return "sha256=" + hmac/' src/auth.py 2>/dev/null || true
}
