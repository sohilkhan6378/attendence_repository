from __future__ import annotations

import uuid
from datetime import date, datetime, time

from django.conf import settings
from django.db import models

from apps.core.models import OrganizationScopedModel, TimeStampedModel
from apps.organization.models import Department, Organization
from apps.users.models import Membership, User


class Shift(OrganizationScopedModel):
    name = models.CharField(max_length=255)
    start_time = models.TimeField()
    end_time = models.TimeField()
    grace_mins = models.PositiveIntegerField(default=10)
    break_policy = models.JSONField(default=dict, blank=True)
    auto_checkout_time = models.TimeField(null=True, blank=True)
    ot_rules = models.JSONField(default=dict, blank=True)
    weekly_offs = models.JSONField(default=list, blank=True)

    class Meta:
        unique_together = ("organization_id", "name")
        ordering = ["name"]

    def __str__(self) -> str:
        return f"{self.name} ({self.organization_id})"


class Policy(OrganizationScopedModel):
    late_cutoff_time = models.TimeField(default=time(hour=10, minute=30))
    rounding_minutes = models.IntegerField(default=10)
    geo_fence_radius_m = models.IntegerField(default=100)
    allowed_edit_days = models.IntegerField(default=7)
    enable_qr = models.BooleanField(default=False)
    enable_face = models.BooleanField(default=True)
    enable_geo = models.BooleanField(default=False)

    class Meta:
        verbose_name_plural = "Policies"


class AttendanceDay(OrganizationScopedModel):
    employee = models.ForeignKey(User, on_delete=models.CASCADE, related_name="attendance_days")
    date = models.DateField()
    check_in = models.DateTimeField(null=True, blank=True)
    check_out = models.DateTimeField(null=True, blank=True)
    total_work_mins = models.IntegerField(default=0)
    total_break_mins = models.IntegerField(default=0)
    status = models.CharField(max_length=20, default="ABSENT")
    auto_checkout = models.BooleanField(default=False)
    notes = models.TextField(blank=True)
    locked = models.BooleanField(default=False)

    class Meta:
        unique_together = ("employee", "date")
        ordering = ["-date"]


class Break(TimeStampedModel):
    day = models.ForeignKey(AttendanceDay, on_delete=models.CASCADE, related_name="breaks")
    start = models.DateTimeField()
    end = models.DateTimeField(null=True, blank=True)
    is_paid = models.BooleanField(default=False)


class PunchSource(models.TextChoices):
    MOBILE = "MOBILE", "Mobile"
    ADMIN = "ADMIN", "Admin"
    AUTO = "AUTO", "Auto"
    IMPORT = "IMPORT", "Import"
    QR = "QR", "QR"
    FACE = "FACE", "Face"


class PunchKind(models.TextChoices):
    CHECKIN = "CHECKIN", "Check-in"
    CHECKOUT = "CHECKOUT", "Check-out"
    BREAK_START = "BREAK_START", "Break start"
    BREAK_END = "BREAK_END", "Break end"
    AUTO_CHECKOUT = "AUTO_CHECKOUT", "Auto checkout"


class PunchEvent(OrganizationScopedModel):
    employee = models.ForeignKey(User, on_delete=models.CASCADE, related_name="punch_events")
    day = models.ForeignKey(AttendanceDay, on_delete=models.CASCADE, related_name="events")
    timestamp = models.DateTimeField()
    kind = models.CharField(max_length=20, choices=PunchKind.choices)
    source = models.CharField(max_length=20, choices=PunchSource.choices)
    payload = models.JSONField(default=dict, blank=True)

    class Meta:
        ordering = ["timestamp"]


class RequestType(models.TextChoices):
    MISSED_CHECKIN = "MISSED_CHECKIN", "Missed check-in"
    MISSED_CHECKOUT = "MISSED_CHECKOUT", "Missed check-out"
    LATE_JUSTIFICATION = "LATE_JUSTIFICATION", "Late justification"
    OTHER = "OTHER", "Other"


class RequestStatus(models.TextChoices):
    PENDING = "PENDING", "Pending"
    APPROVED = "APPROVED", "Approved"
    REJECTED = "REJECTED", "Rejected"


class AttendanceRequest(OrganizationScopedModel):
    employee = models.ForeignKey(User, on_delete=models.CASCADE, related_name="attendance_requests")
    date = models.DateField()
    type = models.CharField(max_length=32, choices=RequestType.choices)
    from_time = models.DateTimeField(null=True, blank=True)
    to_time = models.DateTimeField(null=True, blank=True)
    reason = models.TextField()
    evidence = models.FileField(upload_to="attendance/evidence/", null=True, blank=True)
    status = models.CharField(max_length=20, choices=RequestStatus.choices, default=RequestStatus.PENDING)
    approver = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL, related_name="attendance_approvals")
    decision_note = models.TextField(blank=True)
    timeline = models.JSONField(default=list, blank=True)

    class Meta:
        ordering = ["-created_at"]


class Holiday(OrganizationScopedModel):
    title = models.CharField(max_length=255)
    date = models.DateField()
    region = models.CharField(max_length=100, blank=True)
    recurring = models.BooleanField(default=False)
    imported_by = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL)

    class Meta:
        unique_together = ("organization_id", "date", "title")
        ordering = ["date"]


class MISExportKind(models.TextChoices):
    PER_EMPLOYEE = "PER_EMPLOYEE", "Per employee"
    COMPANY_SUMMARY = "COMPANY_SUMMARY", "Company summary"


class MISExportJob(OrganizationScopedModel):
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    date_range_start = models.DateField()
    date_range_end = models.DateField()
    filters = models.JSONField(default=dict, blank=True)
    status = models.CharField(max_length=20, default="QUEUED")
    file = models.FileField(upload_to="exports/", null=True, blank=True)
    delivered_to = models.JSONField(default=list, blank=True)
    kind = models.CharField(max_length=32, choices=MISExportKind.choices)

    class Meta:
        ordering = ["-created_at"]
