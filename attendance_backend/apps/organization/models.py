from __future__ import annotations

import uuid
from django.conf import settings
from django.db import models

from apps.core.models import TimeStampedModel


class Organization(TimeStampedModel):
    name = models.CharField(max_length=255)
    code = models.SlugField(unique=True)
    timezone = models.CharField(max_length=64, default="Asia/Kolkata")
    settings = models.JSONField(default=dict, blank=True)
    logo = models.ImageField(upload_to="org_logos/", null=True, blank=True)
    domains = models.JSONField(default=list, blank=True)

    class Meta:
        ordering = ["name"]

    def __str__(self) -> str:
        return self.name


class Location(TimeStampedModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name="locations")
    name = models.CharField(max_length=255)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    geo_fence_radius_m = models.IntegerField(default=100)

    class Meta:
        unique_together = ("organization", "name")
        ordering = ["name"]

    def __str__(self) -> str:
        return f"{self.name} ({self.organization.code})"


class Department(TimeStampedModel):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name="departments")
    name = models.CharField(max_length=255)

    class Meta:
        unique_together = ("organization", "name")
        ordering = ["name"]

    def __str__(self) -> str:
        return f"{self.name} ({self.organization.code})"
