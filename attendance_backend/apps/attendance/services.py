from __future__ import annotations

from datetime import datetime
from typing import Optional

from django.db import transaction

from apps.core.utils.time import duration_minutes

from .domain import compute_status
from .models import (
    AttendanceDay,
    AttendanceRequest,
    Break,
    Policy,
    PunchEvent,
    PunchKind,
    PunchSource,
    Shift,
)


def get_or_create_day(org_id, user, day_date) -> AttendanceDay:
    day, _ = AttendanceDay.objects.get_or_create(
        organization_id=org_id,
        employee=user,
        date=day_date,
        defaults={"status": "ABSENT"},
    )
    return day


def register_punch(*, organization_id, employee, day_date, timestamp, kind: str, source: str, payload: dict | None = None) -> AttendanceDay:
    with transaction.atomic():
        day = get_or_create_day(organization_id, employee, day_date)
        if day.locked:
            raise ValueError("Day locked after payroll")

        event = PunchEvent.objects.create(
            organization_id=organization_id,
            employee=employee,
            day=day,
            timestamp=timestamp,
            kind=kind,
            source=source,
            payload=payload or {},
        )

        if kind == PunchKind.CHECKIN:
            day.check_in = timestamp
        elif kind == PunchKind.CHECKOUT:
            if day.breaks.filter(end__isnull=True).exists():
                raise ValueError("Cannot checkout during active break")
            day.check_out = timestamp
        elif kind == PunchKind.BREAK_START:
            Break.objects.create(day=day, start=timestamp, is_paid=payload.get("is_paid", False))
        elif kind == PunchKind.BREAK_END:
            active_break = day.breaks.filter(end__isnull=True).last()
            if not active_break:
                raise ValueError("No active break")
            active_break.end = timestamp
            active_break.save(update_fields=["end"])

        day.save()
        return day


def recalculate_day(day: AttendanceDay, policy: Policy, shift: Shift) -> AttendanceDay:
    result = compute_status(day, policy, shift)
    day.status = result.status
    day.total_work_mins = result.total_work_mins
    day.total_break_mins = result.total_break_mins
    day.auto_checkout = result.auto_checkout
    day.save(update_fields=["status", "total_work_mins", "total_break_mins", "auto_checkout"])
    return day


def handle_auto_checkout(day: AttendanceDay, policy: Policy, shift: Shift) -> AttendanceDay:
    if day.auto_checkout:
        return day
    timestamp = datetime.combine(day.date, shift.auto_checkout_time, tzinfo=day.check_in.tzinfo)
    register_punch(
        organization_id=day.organization_id,
        employee=day.employee,
        day_date=day.date,
        timestamp=timestamp,
        kind=PunchKind.AUTO_CHECKOUT,
        source=PunchSource.AUTO,
    )
    day.auto_checkout = True
    day.check_out = timestamp
    day.save(update_fields=["auto_checkout", "check_out"])
    return day


def approve_request(request: AttendanceRequest, approver, decision_note: str) -> AttendanceRequest:
    request.status = request.status.APPROVED
    request.approver = approver
    request.decision_note = decision_note
    timeline = request.timeline
    timeline.append({"actor": approver.email, "action": "APPROVED", "note": decision_note})
    request.timeline = timeline
    request.save(update_fields=["status", "approver", "decision_note", "timeline"])
    return request


def reject_request(request: AttendanceRequest, approver, decision_note: str) -> AttendanceRequest:
    request.status = request.status.REJECTED
    request.approver = approver
    request.decision_note = decision_note
    timeline = request.timeline
    timeline.append({"actor": approver.email, "action": "REJECTED", "note": decision_note})
    request.timeline = timeline
    request.save(update_fields=["status", "approver", "decision_note", "timeline"])
    return request
