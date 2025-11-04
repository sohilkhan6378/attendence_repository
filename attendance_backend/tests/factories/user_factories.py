from __future__ import annotations

import factory
from django.contrib.auth import get_user_model

from apps.users.models import Membership, MembershipRole
from .org_factories import DepartmentFactory, OrganizationFactory

User = get_user_model()


class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User

    email = factory.Sequence(lambda n: f"user{n}@example.com")
    first_name = "User"
    password = factory.PostGenerationMethodCall("set_password", "password")


class MembershipFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Membership

    user = factory.SubFactory(UserFactory)
    organization = factory.SubFactory(OrganizationFactory)
    role = MembershipRole.EMPLOYEE
    department = factory.SubFactory(DepartmentFactory)
    shift_id = factory.Faker("uuid4")
