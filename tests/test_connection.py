import pytest
from src.connection import ConnectionPool


def test_pool_acquires_connection():
    pool = ConnectionPool(max_connections=5)
    assert pool.acquire()
    assert pool.available == 4


def test_pool_exhaustion_raises():
    pool = ConnectionPool(max_connections=2)
    pool.acquire()
    pool.acquire()
    with pytest.raises(RuntimeError, match="pool exhausted"):
        pool.acquire()


def test_pool_release_frees_slot():
    pool = ConnectionPool(max_connections=1)
    pool.acquire()
    pool.release()
    assert pool.acquire()


def test_pool_available_counts_correctly():
    pool = ConnectionPool(max_connections=3)
    assert pool.available == 3
    pool.acquire()
    pool.acquire()
    assert pool.available == 1
