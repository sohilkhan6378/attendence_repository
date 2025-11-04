from __future__ import annotations

from datetime import date
from typing import Iterable

from django.db.models import QuerySet

from apps.core.utils.excel import build_workbook

from .models import AttendanceDay, MISExportKind, MISExportJob


def per_employee_rows(days: QuerySet[AttendanceDay]) -> Iterable[list[str]]:
    for day in days.select_related("employee"):
        yield [
            str(day.date),
            day.employee.email,
            day.employee.get_full_name() or day.employee.email,
            day.employee.memberships.first().department.name if day.employee.memberships.first() and day.employee.memberships.first().department else "",
            "-",
            day.check_in.isoformat() if day.check_in else "",
            day.check_out.isoformat() if day.check_out else "",
            f"{day.total_work_mins // 60:02d}:{day.total_work_mins % 60:02d}",
            f"{day.total_break_mins // 60:02d}:{day.total_break_mins % 60:02d}",
            "Yes" if day.status == "LATE" else "No",
            "Yes" if day.status == "HALF_DAY" else "No",
            "00:00",
            day.status,
            "Yes" if day.auto_checkout else "No",
            "-",
            day.employee.memberships.first().department.name if day.employee.memberships.first() and day.employee.memberships.first().department else "",
            day.notes,
        ]


def per_employee_xlsx(org_id, employee, start: date, end: date) -> bytes:
    days = AttendanceDay.objects.filter(
        organization_id=org_id,
        employee=employee,
        date__range=(start, end),
    )
    return build_workbook(per_employee_rows(days))


def company_summary_xlsx(org_id, start: date, end: date) -> bytes:
    days = AttendanceDay.objects.filter(organization_id=org_id, date__range=(start, end))
    return build_workbook(per_employee_rows(days))


def build_export(job: MISExportJob) -> bytes:
    if job.kind == MISExportKind.PER_EMPLOYEE:
        employee = job.filters.get("employee_id")
        return per_employee_xlsx(job.organization_id, employee, job.date_range_start, job.date_range_end)
    return company_summary_xlsx(job.organization_id, job.date_range_start, job.date_range_end)
