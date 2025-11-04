from __future__ import annotations

import factory

from apps.organization.models import Department, Location, Organization


class OrganizationFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Organization

    name = factory.Sequence(lambda n: f"Org {n}")
    code = factory.Sequence(lambda n: f"org{n}")
    timezone = "Asia/Kolkata"


class LocationFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Location

    organization = factory.SubFactory(OrganizationFactory)
    name = factory.Sequence(lambda n: f"Location {n}")


class DepartmentFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Department

    organization = factory.SubFactory(OrganizationFactory)
    name = factory.Sequence(lambda n: f"Department {n}")
