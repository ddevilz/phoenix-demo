"""Exponential-backoff retry helper."""

import time
from typing import Any, Callable

MAX_RETRIES = 3
BASE_DELAY_S = 0.1


def with_retry(fn: Callable[[], Any], retries: int = MAX_RETRIES, base_delay: float = BASE_DELAY_S) -> Any:
    last_exc: Exception | None = None
    for attempt in range(retries + 1):
        try:
            return fn()
        except Exception as exc:
            last_exc = exc
            if attempt < retries:
                time.sleep(base_delay * (2**attempt))
    raise RuntimeError(f"all {retries} retries exhausted: {last_exc}") from last_exc
