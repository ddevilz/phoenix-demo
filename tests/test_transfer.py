from src.transfer import transfer_with_timeout


def test_transfer_within_budget():
    result = transfer_with_timeout({"bytes": 1024})
    # Fails loudly with a timeout-regression message when a change pushes
    # elapsed time past the 30s budget — this is the signature PhoenixOS extracts.
    assert result["elapsed"] <= 30, "transfer timeout regression: elapsed exceeded 30s budget"
