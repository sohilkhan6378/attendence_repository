from __future__ import annotations

import django_filters

from .models import Department, Location


class LocationFilter(django_filters.FilterSet):
    class Meta:
        model = Location
        fields = {"name": ["icontains"]}


class DepartmentFilter(django_filters.FilterSet):
    class Meta:
        model = Department
        fields = {"name": ["icontains"]}
