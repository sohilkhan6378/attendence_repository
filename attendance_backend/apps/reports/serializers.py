from __future__ import annotations

from datetime import date

from rest_framework import serializers


class ReportRequestSerializer(serializers.Serializer):
    start = serializers.DateField(default=date.today)
    end = serializers.DateField(default=date.today)
    employee_id = serializers.UUIDField(required=False)
