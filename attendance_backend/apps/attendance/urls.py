from __future__ import annotations

from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import (
    AttendanceDayViewSet,
    AttendanceRequestViewSet,
    BreakEndView,
    BreakStartView,
    CheckInView,
    CheckOutView,
    MISExportJobViewSet,
    TodayView,
)

router = DefaultRouter()
router.register(r"attendance/days", AttendanceDayViewSet, basename="attendance-day")
router.register(r"requests", AttendanceRequestViewSet, basename="attendance-request")
router.register(r"admin/reports/export", MISExportJobViewSet, basename="mis-export")

urlpatterns = [
    path("attendance/punch/checkin/", CheckInView.as_view(), name="attendance-checkin"),
    path("attendance/punch/checkout/", CheckOutView.as_view(), name="attendance-checkout"),
    path("attendance/punch/break/start/", BreakStartView.as_view(), name="attendance-break-start"),
    path("attendance/punch/break/end/", BreakEndView.as_view(), name="attendance-break-end"),
    path("attendance/today/", TodayView.as_view(), name="attendance-today"),
]

urlpatterns += router.urls
