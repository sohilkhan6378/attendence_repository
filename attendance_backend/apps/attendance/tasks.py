from __future__ import annotations

from datetime import date

from celery import shared_task

from .models import AttendanceDay, Policy, Shift
from .services import handle_auto_checkout, recalculate_day


@shared_task
def run_auto_checkout() -> None:
    today = date.today()
    for day in AttendanceDay.objects.filter(date=today, auto_checkout=False, check_in__isnull=False):
        policy = Policy.objects.filter(organization_id=day.organization_id).first()
        membership = day.employee.memberships.filter(organization_id=day.organization_id).first()
        shift_id = membership.shift_id if membership else None
        shift = Shift.objects.filter(organization_id=day.organization_id, id=shift_id).first()
        if policy and shift and shift.auto_checkout_time:
            handle_auto_checkout(day, policy, shift)


@shared_task
def recompute_attendance_totals() -> None:
    for day in AttendanceDay.objects.filter(check_in__isnull=False):
        policy = Policy.objects.filter(organization_id=day.organization_id).first()
        membership = day.employee.memberships.filter(organization_id=day.organization_id).first()
        shift_id = membership.shift_id if membership else None
        shift = Shift.objects.filter(organization_id=day.organization_id, id=shift_id).first()
        if policy and shift:
            recalculate_day(day, policy, shift)
