from __future__ import annotations

from io import BytesIO
from typing import Iterable

from openpyxl import Workbook


MIS_COLUMNS = [
    "Date",
    "Employee Code",
    "Employee Name",
    "Department",
    "Shift (Start–End)",
    "Check-in",
    "Check-out",
    "Total Work (hh:mm)",
    "Total Break (hh:mm)",
    "Late (Y/N)",
    "Half Day (Y/N)",
    "Overtime (hh:mm)",
    "Status",
    "Auto Checkout (Y/N)",
    "Location/Geo",
    "Manager",
    "Notes",
]


def build_workbook(rows: Iterable[Iterable[str]]) -> bytes:
    wb = Workbook()
    ws = wb.active
    ws.title = "Attendance"
    ws.append(MIS_COLUMNS)
    for row in rows:
        ws.append(list(row))
    stream = BytesIO()
    wb.save(stream)
    return stream.getvalue()
