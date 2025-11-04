from __future__ import annotations

import datetime

import factory

from apps.attendance.models import AttendanceDay, Policy, Shift
from .org_factories import OrganizationFactory
from .user_factories import MembershipFactory


class ShiftFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Shift

    organization_id = factory.SelfAttribute("organization.id")
    organization = factory.SubFactory(OrganizationFactory)
    name = factory.Sequence(lambda n: f"Shift {n}")
    start_time = datetime.time(9, 30)
    end_time = datetime.time(18, 30)
    grace_mins = 10
    auto_checkout_time = datetime.time(20, 0)
    break_policy = {"count": None, "paid": False}


class PolicyFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Policy

    organization_id = factory.SelfAttribute("organization.id")
    organization = factory.SubFactory(OrganizationFactory)


class AttendanceDayFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = AttendanceDay

    organization_id = factory.LazyAttribute(lambda o: o.employee.memberships.first().organization_id)
    employee = factory.SubFactory(MembershipFactory)
    date = factory.LazyFunction(datetime.date.today)
    check_in = factory.LazyFunction(lambda: datetime.datetime.now(datetime.timezone.utc))
    check_out = factory.LazyFunction(lambda: datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=8))
    status = "PRESENT"
    total_work_mins = 480
    total_break_mins = 60
