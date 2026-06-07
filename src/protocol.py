"""Minimal protocol state machine: IDLE → CONNECTING → ACTIVE → CLOSED."""

from enum import Enum


class State(Enum):
    IDLE = "idle"
    CONNECTING = "connecting"
    ACTIVE = "active"
    CLOSED = "closed"


_VALID_TRANSITIONS: dict[State, set[State]] = {
    State.IDLE: {State.CONNECTING},
    State.CONNECTING: {State.ACTIVE, State.CLOSED},
    State.ACTIVE: {State.CLOSED},
    State.CLOSED: set(),
}


class Protocol:
    def __init__(self) -> None:
        self.state = State.IDLE
        self.bytes_sent = 0

    def transition(self, target: State) -> None:
        allowed = _VALID_TRANSITIONS[self.state]
        if target not in allowed:
            raise RuntimeError(
                f"illegal transition {self.state.value} → {target.value}"
            )
        self.state = target

    def send(self, data: bytes) -> int:
        if self.state != State.ACTIVE:
            raise RuntimeError(f"cannot send in state {self.state.value}")
        self.bytes_sent += len(data)
        return len(data)
