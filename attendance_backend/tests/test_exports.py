from __future__ import annotations

from datetime import date

import pytest

from apps.attendance.exports import company_summary_xlsx, per_employee_xlsx
from apps.attendance.models import AttendanceDay
from tests.factories.attendance_factories import AttendanceDayFactory


@pytest.mark.django_db
def test_per_employee_export_generates_bytes():
    day = AttendanceDayFactory()
    content = per_employee_xlsx(day.organization_id, day.employee, date.today(), date.today())
    assert isinstance(content, (bytes, bytearray))
    assert len(content) > 0


@pytest.mark.django_db
def test_company_summary_export_generates_bytes():
    day = AttendanceDayFactory()
    AttendanceDayFactory(organization_id=day.organization_id)
    content = company_summary_xlsx(day.organization_id, date.today(), date.today())
    assert isinstance(content, (bytes, bytearray))
    assert len(content) > 0
