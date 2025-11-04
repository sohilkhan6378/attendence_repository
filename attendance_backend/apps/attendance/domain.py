from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime, time
from typing import Iterable, Optional

from .models import AttendanceDay, Break, Policy, PunchEvent, PunchKind, Shift


@dataclass
class PolicyResult:
    status: str
    auto_checkout: bool
    total_work_mins: int
    total_break_mins: int
    copy: str


def compute_status(day: AttendanceDay, policy: Policy, shift: Shift) -> PolicyResult:
    if not day.check_in:
        return PolicyResult(status="ABSENT", auto_checkout=False, total_work_mins=0, total_break_mins=0, copy="Absent")

    late_cutoff = datetime.combine(day.date, policy.late_cutoff_time, tzinfo=day.check_in.tzinfo)
    shift_start = datetime.combine(day.date, shift.start_time, tzinfo=day.check_in.tzinfo)

    total_break = sum(_break_minutes(b) for b in day.breaks.all())
    checkout_time = day.check_out or day.check_in
    work_minutes = int((checkout_time - day.check_in).total_seconds() // 60) - total_break

    if day.check_in > late_cutoff:
        status = "HALF_DAY"
        copy = "Late after 10:30 → Half Day"
    elif day.check_in > shift_start + _minutes(shift.grace_mins):
        status = "LATE"
        copy = "Reached after grace period"
    else:
        status = "PRESENT"
        copy = "On time"

    return PolicyResult(
        status=status,
        auto_checkout=day.auto_checkout,
        total_work_mins=max(work_minutes, 0),
        total_break_mins=total_break,
        copy=copy,
    )


def _minutes(value: int):
    from datetime import timedelta

    return timedelta(minutes=value)


def _break_minutes(break_obj: Break) -> int:
    if not break_obj.end:
        return 0
    return int((break_obj.end - break_obj.start).total_seconds() // 60)


def auto_checkout_required(day: AttendanceDay, shift: Shift) -> bool:
    if day.check_out or not shift.auto_checkout_time:
        return False
    auto_time = datetime.combine(day.date, shift.auto_checkout_time, tzinfo=day.check_in.tzinfo if day.check_in else None)
    now = datetime.now(tz=day.check_in.tzinfo)
    return now >= auto_time


def summarize_events(events: Iterable[PunchEvent]) -> list[dict[str, str]]:
    timeline = []
    for event in events:
        timeline.append(
            {
                "timestamp": event.timestamp.isoformat(),
                "kind": event.kind,
                "source": event.source,
            }
        )
    return timeline
