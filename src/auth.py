"""HMAC request signing for the demo auth layer."""

import hashlib
import hmac

_SECRET_KEY = "demo-secret-key"


def sign_request(payload: bytes, secret: str = _SECRET_KEY) -> str:
    return "sha256=" + hmac.new(secret.encode(), payload, hashlib.sha256).hexdigest()


def verify_signature(payload: bytes, signature: str, secret: str = _SECRET_KEY) -> bool:
    expected = sign_request(payload, secret)
    return hmac.compare_digest(expected, signature)
