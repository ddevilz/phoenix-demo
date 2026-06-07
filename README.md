# phoenix-demo

Test repo for [PhoenixOS](https://phoenixos.onrender.com) — a live CI failure intelligence system.

Green on `main`. Run `./pr.sh` to introduce three simultaneous regressions as a Pull Request.
PhoenixOS ingests the CI failure, extracts failure signatures via NVIDIA NIM, updates the memory
graph, and scores the PR with 3 parallel AI judges.

---

## Try it yourself (2 minutes)

### Option A — Just run the Eval (no setup needed)

1. Open **[phoenixos.onrender.com](https://phoenixos.onrender.com)**
2. Click **Evals** in the nav
3. Paste this PR URL and click **Run Eval**:
   ```
   https://github.com/ddevilz/phoenix-demo/pull/2
   ```
4. Watch 3 NVIDIA NIM judges score the diff in parallel (~30s)
5. See **Trust Score + BLOCK verdict + flags** appear
6. Click **Trust Ledger** to see the immutable result entry

### Option B — Trigger the full live flow (requires repo access)

```bash
git clone https://github.com/ddevilz/phoenix-demo
cd phoenix-demo

./pr.sh        # creates branch + PR with 3 regressions, prints PR URL
```

Then:
1. Paste the printed PR URL into **phoenixos.onrender.com/evals** → Run Eval
2. Switch to **Memory Graph** — new node appears within ~45s of CI finishing
3. Run `./reset.sh` to close the PR, delete the branch, and restore green

---

## What the regressions do

| File | Change | Test that fails |
|------|--------|-----------------|
| `src/auth.py` | HMAC prefix `sha256=` → `sha1=` | `test_signature_has_sha256_prefix`, `test_signature_length` |
| `src/connection.py` | `MAX_CONNECTIONS = 10` → `0` | `test_connection_pool_limit` |
| `src/transfer.py` | `return 12` → `return 42` | `test_transfer_within_budget` |

These look like performance optimizations in the diff. PhoenixOS catches all three.

---

## What PhoenixOS does with the failure

1. GitHub Actions runs `pytest` → tests fail
2. CI posts the log tail to PhoenixOS with an HMAC-signed webhook
3. NVIDIA NIM (minimax-m2.7) extracts a `FailureSignature` from the log
4. NIM (nv-embed-v1) computes a 1024-dim embedding; cosine similarity finds related past failures
5. Neo4j Aura stores the new node + `SIMILAR_TO` edges to the existing auth/pool cluster
6. PageRank recomputes fragility scores — node color updates on the live graph

---

## Scripts

```bash
./pr.sh      # create branch + PR with regressions → prints PR URL
./break.sh   # push regressions directly to main (no PR)
./reset.sh   # restore main to green, close PR, delete branch
```

Adding a new regression: edit `lib/regressions.sh` only — all three scripts source it.
