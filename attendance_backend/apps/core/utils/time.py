from __future__ import annotations

from datetime import datetime, time, timedelta

import pytz


def to_org_timezone(value: datetime, timezone: str) -> datetime:
    tz = pytz.timezone(timezone)
    if value.tzinfo is None:
        value = value.replace(tzinfo=pytz.UTC)
    return value.astimezone(tz)


def round_minutes(total_minutes: int, rounding: int) -> int:
    if rounding <= 0:
        return total_minutes
    return int(round(total_minutes / rounding) * rounding)


def combine(date_value, time_value: time, timezone: str) -> datetime:
    tz = pytz.timezone(timezone)
    dt = datetime.combine(date_value, time_value)
    return tz.localize(dt)


def duration_minutes(start: datetime, end: datetime) -> int:
    return int((end - start).total_seconds() // 60)
