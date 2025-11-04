from __future__ import annotations

from datetime import datetime

from rest_framework import serializers

from apps.core.utils.time import round_minutes
from apps.users.serializers import UserSerializer

from .domain import summarize_events
from .models import (
    AttendanceDay,
    AttendanceRequest,
    Break,
    MISExportJob,
    Policy,
    PunchEvent,
    PunchKind,
    Shift,
)


class BreakSerializer(serializers.ModelSerializer):
    class Meta:
        model = Break
        fields = ["id", "start", "end", "is_paid"]


class AttendanceDaySerializer(serializers.ModelSerializer):
    breaks = BreakSerializer(many=True, read_only=True)
    employee = UserSerializer(read_only=True)

    class Meta:
        model = AttendanceDay
        fields = [
            "id",
            "employee",
            "date",
            "check_in",
            "check_out",
            "status",
            "total_work_mins",
            "total_break_mins",
            "auto_checkout",
            "notes",
            "breaks",
        ]


class PunchSerializer(serializers.Serializer):
    timestamp = serializers.DateTimeField(default_factory=datetime.now)
    device = serializers.CharField(required=False)
    geo = serializers.DictField(child=serializers.FloatField(), required=False)
    payload = serializers.DictField(required=False)


class AttendanceRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = AttendanceRequest
        fields = [
            "id",
            "date",
            "type",
            "from_time",
            "to_time",
            "reason",
            "status",
            "approver",
            "decision_note",
            "timeline",
        ]
        read_only_fields = ["status", "approver", "decision_note", "timeline"]


class DashboardSerializer(serializers.Serializer):
    status_chip = serializers.CharField()
    copy = serializers.CharField()
    check_in = serializers.DateTimeField(allow_null=True)
    check_out = serializers.DateTimeField(allow_null=True)
    total_work = serializers.CharField()
    total_break = serializers.CharField()
    auto_checkout = serializers.BooleanField()
    timeline = serializers.ListField(child=serializers.DictField())


class PolicySerializer(serializers.ModelSerializer):
    class Meta:
        model = Policy
        fields = [
            "id",
            "late_cutoff_time",
            "rounding_minutes",
            "geo_fence_radius_m",
            "allowed_edit_days",
            "enable_qr",
            "enable_face",
            "enable_geo",
        ]


class ShiftSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shift
        fields = [
            "id",
            "name",
            "start_time",
            "end_time",
            "grace_mins",
            "break_policy",
            "auto_checkout_time",
            "ot_rules",
            "weekly_offs",
        ]


class MISExportJobSerializer(serializers.ModelSerializer):
    class Meta:
        model = MISExportJob
        fields = [
            "id",
            "kind",
            "status",
            "date_range_start",
            "date_range_end",
            "file",
            "created_at",
        ]
