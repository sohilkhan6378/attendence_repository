from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable


@dataclass
class NotificationMessage:
    subject: str
    body: str
    recipients: Iterable[str]


def send_notification(message: NotificationMessage) -> None:
    """Placeholder notification dispatcher that can integrate with email/FCM/Slack."""

    # In production wire this to email gateways or async tasks.
    for recipient in message.recipients:  # pragma: no cover - illustrative
        print(f"Sending notification to {recipient}: {message.subject}")
