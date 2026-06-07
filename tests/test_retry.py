import pytest
from src.retry import with_retry


def test_succeeds_first_attempt():
    calls: list[int] = []

    def fn() -> str:
        calls.append(1)
        return "ok"

    assert with_retry(fn) == "ok"
    assert len(calls) == 1


def test_retries_on_transient_failure():
    attempts: list[int] = []

    def flaky() -> str:
        attempts.append(1)
        if len(attempts) < 3:
            raise ValueError("transient error")
        return "ok"

    result = with_retry(flaky, retries=3, base_delay=0)
    assert result == "ok"
    assert len(attempts) == 3


def test_raises_after_max_retries():
    def always_fail() -> None:
        raise ValueError("always fails")

    with pytest.raises(RuntimeError, match="retries exhausted"):
        with_retry(always_fail, retries=2, base_delay=0)


def test_zero_retries_raises_immediately():
    def fail() -> None:
        raise ValueError("boom")

    with pytest.raises(RuntimeError):
        with_retry(fail, retries=0, base_delay=0)
