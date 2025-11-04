from __future__ import annotations

from django.urls import path

from .views import AdminReportExportView, MyReportExportView

urlpatterns = [
    path("reports/my/export/", MyReportExportView.as_view(), name="reports-my-export"),
    path("admin/reports/download/", AdminReportExportView.as_view(), name="reports-admin-export"),
]
