from __future__ import annotations

import django_filters

from .models import AttendanceDay


class AttendanceDayFilter(django_filters.FilterSet):
    date = django_filters.DateFilter()

    class Meta:
        model = AttendanceDay
        fields = {"status": ["exact"], "date": ["exact", "lte", "gte"]}
