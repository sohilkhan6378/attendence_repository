from __future__ import annotations

from django.contrib import admin

from .models import Department, Location, Organization


@admin.register(Organization)
class OrganizationAdmin(admin.ModelAdmin):
    list_display = ("name", "code", "timezone")
    search_fields = ("name", "code")


@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ("name", "organization", "geo_fence_radius_m")
    list_filter = ("organization",)


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ("name", "organization")
    list_filter = ("organization",)
