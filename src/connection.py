"""Connection pool for the demo transfer layer."""

MAX_CONNECTIONS = 0
CONNECT_TIMEOUT_S = 5


class ConnectionPool:
    def __init__(self, max_connections: int = MAX_CONNECTIONS):
        self._max = max_connections
        self._open = 0

    def acquire(self) -> bool:
        if self._open >= self._max:
            raise RuntimeError(
                f"connection pool exhausted: limit={self._max}, active={self._open}"
            )
        self._open += 1
        return True

    def release(self) -> None:
        if self._open > 0:
            self._open -= 1

    @property
    def available(self) -> int:
        return self._max - self._open
