from __future__ import annotations

import uuid
from django.contrib.auth.models import AbstractUser
from django.db import models

from apps.core.models import TimeStampedModel
from apps.organization.models import Department, Organization


class User(AbstractUser):
    username = None
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=20, blank=True)
    default_org = models.ForeignKey(Organization, null=True, blank=True, on_delete=models.SET_NULL, related_name="default_users")

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS: list[str] = []

    def __str__(self) -> str:
        return self.email


class MembershipRole(models.TextChoices):
    EMPLOYEE = "EMPLOYEE", "Employee"
    MANAGER = "MANAGER", "Manager"
    ADMIN = "ADMIN", "Admin"


class Membership(TimeStampedModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="memberships")
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name="memberships")
    role = models.CharField(max_length=20, choices=MembershipRole.choices)
    department = models.ForeignKey(Department, null=True, blank=True, on_delete=models.SET_NULL)
    shift_id = models.UUIDField(null=True, blank=True)

    class Meta:
        unique_together = ("user", "organization")

    def __str__(self) -> str:
        return f"{self.user.email} -> {self.organization.code} ({self.role})"
