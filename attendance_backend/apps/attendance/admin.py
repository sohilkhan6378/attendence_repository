from __future__ import annotations

from django.contrib import admin

from .models import (
    AttendanceDay,
    AttendanceRequest,
    Break,
    Holiday,
    MISExportJob,
    Policy,
    PunchEvent,
    Shift,
)


@admin.register(Shift)
class ShiftAdmin(admin.ModelAdmin):
    list_display = ("name", "organization_id", "start_time", "end_time")
    search_fields = ("name",)


@admin.register(Policy)
class PolicyAdmin(admin.ModelAdmin):
    list_display = ("organization_id", "late_cutoff_time", "rounding_minutes")


@admin.register(AttendanceDay)
class AttendanceDayAdmin(admin.ModelAdmin):
    list_display = ("employee", "date", "status", "auto_checkout")
    list_filter = ("status", "auto_checkout")


@admin.register(Break)
class BreakAdmin(admin.ModelAdmin):
    list_display = ("day", "start", "end", "is_paid")


@admin.register(PunchEvent)
class PunchEventAdmin(admin.ModelAdmin):
    list_display = ("employee", "timestamp", "kind", "source")
    list_filter = ("kind", "source")


@admin.register(AttendanceRequest)
class AttendanceRequestAdmin(admin.ModelAdmin):
    list_display = ("employee", "date", "type", "status")
    list_filter = ("status", "type")


@admin.register(Holiday)
class HolidayAdmin(admin.ModelAdmin):
    list_display = ("title", "date", "region", "organization_id")


@admin.register(MISExportJob)
class MISExportJobAdmin(admin.ModelAdmin):
    list_display = ("organization_id", "kind", "status", "created_at")
    list_filter = ("kind", "status")
