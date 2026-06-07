import pytest
from src.protocol import Protocol, State


def test_initial_state_is_idle():
    p = Protocol()
    assert p.state == State.IDLE


def test_valid_lifecycle():
    p = Protocol()
    p.transition(State.CONNECTING)
    p.transition(State.ACTIVE)
    p.transition(State.CLOSED)
    assert p.state == State.CLOSED


def test_send_in_active_state():
    p = Protocol()
    p.transition(State.CONNECTING)
    p.transition(State.ACTIVE)
    sent = p.send(b"payload data")
    assert sent == 12
    assert p.bytes_sent == 12


def test_send_outside_active_raises():
    p = Protocol()
    with pytest.raises(RuntimeError, match="cannot send in state idle"):
        p.send(b"data")


def test_illegal_transition_raises():
    p = Protocol()
    with pytest.raises(RuntimeError, match="illegal transition"):
        p.transition(State.ACTIVE)  # IDLE → ACTIVE is invalid


def test_closed_state_is_terminal():
    p = Protocol()
    p.transition(State.CONNECTING)
    p.transition(State.CLOSED)
    with pytest.raises(RuntimeError, match="illegal transition"):
        p.transition(State.CONNECTING)
