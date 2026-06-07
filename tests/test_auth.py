from src.auth import sign_request, verify_signature


def test_signature_round_trip():
    payload = b"hello world"
    sig = sign_request(payload)
    assert verify_signature(payload, sig)


def test_wrong_payload_rejected():
    payload = b"hello world"
    sig = sign_request(payload)
    assert not verify_signature(b"tampered payload", sig)


def test_wrong_secret_rejected():
    payload = b"hello world"
    sig = sign_request(payload, secret="correct-secret")
    assert not verify_signature(payload, sig, secret="wrong-secret")


def test_signature_has_sha256_prefix():
    sig = sign_request(b"test")
    assert sig.startswith("sha256=")


def test_signature_length():
    sig = sign_request(b"data")
    # sha256= + 64 hex chars
    assert len(sig) == 71
