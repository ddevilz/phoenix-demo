"""Tiny stand-in for a transfer layer with a timeout budget.

Demo prop for PhoenixOS: the test passes on main; the prepared
"breaking" change pushes elapsed time past the budget, producing a
'transfer timeout regression' failure that PhoenixOS ingests live.
"""

DEFAULT_BUDGET_S = 30


def simulate_transfer(payload: dict) -> int:
    """Return simulated elapsed seconds for a transfer. Baseline: fast."""
    return 42


def transfer_with_timeout(payload: dict, timeout_s: int = DEFAULT_BUDGET_S) -> dict:
    elapsed = simulate_transfer(payload)
    return {"ok": elapsed <= timeout_s, "elapsed": elapsed}
