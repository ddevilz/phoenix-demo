# phoenix-demo

Throwaway repo to drive a **live PhoenixOS demo**. A real GitHub Actions test
suite that is green on `main` and fails on cue when you run `./break.sh`.

The failing test emits a **`transfer timeout regression`** message. PhoenixOS
extracts that as a failure signature; because it resembles the seeded
`curl/curl` `lib/transfer.c` timeout cluster, the new node arrives in the graph
**connected by a `SIMILAR_TO` edge**, with a populated blast radius.

## Live demo

1. PhoenixOS running locally (`docker compose -f infra/docker-compose.yml up`), dashboard open, graph seeded.
2. Tunnel exposing the core API: `cloudflared tunnel --url http://localhost:8000`.
3. This repo's webhook (Settings → Webhooks) → Payload URL `<tunnel>/api/webhooks/github`,
   content type `application/json`, secret = `GITHUB_WEBHOOK_SECRET`, event **"Workflow runs"**.
4. During the demo, run:

   ```bash
   ./break.sh     # introduces the regression, pushes → CI fails → node pulses into the graph
   ```

5. To re-run the demo, restore green:

   ```bash
   ./reset.sh
   ```

## Files

- `src/transfer.py` — transfer layer with a 30s budget (`break.sh` flips elapsed 12 → 42).
- `tests/test_transfer.py` — asserts elapsed ≤ 30s.
- `.github/workflows/ci.yml` — runs `pytest` on every push/PR.
