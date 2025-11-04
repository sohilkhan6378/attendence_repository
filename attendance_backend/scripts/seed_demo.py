from __future__ import annotations

import random
from datetime import date, datetime, time, timedelta

from django.contrib.auth import get_user_model

from apps.attendance.models import AttendanceDay, Policy, Shift
from apps.organization.models import Department, Location, Organization
from apps.users.models import Membership, MembershipRole

User = get_user_model()


def run() -> None:
    org, _ = Organization.objects.get_or_create(name="Acme Corp", code="acme")
    org.timezone = "Asia/Kolkata"
    org.save()

    loc1, _ = Location.objects.get_or_create(organization=org, name="Bangalore")
    loc2, _ = Location.objects.get_or_create(organization=org, name="Mumbai")

    dept_sales, _ = Department.objects.get_or_create(organization=org, name="Sales")
    dept_eng, _ = Department.objects.get_or_create(organization=org, name="Engineering")
    dept_hr, _ = Department.objects.get_or_create(organization=org, name="HR")

    shift, _ = Shift.objects.get_or_create(
        organization_id=org.id,
        name="General",
        defaults={
            "start_time": time(9, 30),
            "end_time": time(18, 30),
            "grace_mins": 10,
            "auto_checkout_time": time(20, 0),
            "break_policy": {"count": None, "paid": False, "maxBreaks": 3},
        },
    )

    Policy.objects.get_or_create(organization_id=org.id)

    admin, _ = User.objects.get_or_create(email="admin@acme.com", defaults={"first_name": "Admin"})
    admin.set_password("password")
    admin.save()
    Membership.objects.get_or_create(user=admin, organization=org, role=MembershipRole.ADMIN, shift_id=shift.id, department=dept_hr)

    for i in range(2):
        manager, _ = User.objects.get_or_create(email=f"manager{i}@acme.com")
        manager.set_password("password")
        manager.save()
        Membership.objects.get_or_create(
            user=manager,
            organization=org,
            role=MembershipRole.MANAGER,
            shift_id=shift.id,
            department=random.choice([dept_sales, dept_eng]),
        )

    for i in range(10):
        employee, _ = User.objects.get_or_create(email=f"employee{i}@acme.com")
        employee.set_password("password")
        employee.save()
        Membership.objects.get_or_create(
            user=employee,
            organization=org,
            role=MembershipRole.EMPLOYEE,
            shift_id=shift.id,
            department=random.choice([dept_sales, dept_eng, dept_hr]),
        )
        for offset in range(5):
            day_date = date.today() - timedelta(days=offset)
            check_in = datetime.combine(day_date, time(9, 30)) + timedelta(minutes=random.randint(0, 60))
            check_out = check_in + timedelta(hours=8)
            AttendanceDay.objects.get_or_create(
                organization_id=org.id,
                employee=employee,
                date=day_date,
                defaults={
                    "check_in": check_in,
                    "check_out": check_out,
                    "status": "PRESENT",
                    "total_work_mins": 8 * 60,
                    "total_break_mins": 60,
                },
            )
