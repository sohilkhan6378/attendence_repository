from __future__ import annotations

from datetime import datetime, timedelta, timezone

import pytest

from apps.attendance.domain import compute_status
from apps.attendance.models import AttendanceDay
from tests.factories.attendance_factories import PolicyFactory, ShiftFactory
from tests.factories.user_factories import MembershipFactory


@pytest.mark.django_db
def test_policy_marks_half_day_when_after_cutoff():
    membership = MembershipFactory()
    policy = PolicyFactory(organization=membership.organization)
    shift = ShiftFactory(organization=membership.organization)
    day = AttendanceDay.objects.create(
        organization_id=membership.organization.id,
        employee=membership.user,
        date=datetime.now().date(),
        check_in=datetime.now(timezone.utc) + timedelta(hours=2),
    )
    result = compute_status(day, policy, shift)
    assert result.status == "HALF_DAY"


@pytest.mark.django_db
def test_policy_late_within_grace():
    membership = MembershipFactory()
    policy = PolicyFactory(organization=membership.organization)
    shift = ShiftFactory(organization=membership.organization)
    day = AttendanceDay.objects.create(
        organization_id=membership.organization.id,
        employee=membership.user,
        date=datetime.now().date(),
        check_in=datetime.now(timezone.utc) + timedelta(minutes=15),
    )
    result = compute_status(day, policy, shift)
    assert result.status in {"LATE", "PRESENT"}
