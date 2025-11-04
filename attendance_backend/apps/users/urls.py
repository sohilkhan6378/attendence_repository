from __future__ import annotations

from django.urls import path

from .views import AttendanceTokenRefreshView, CurrentOrganizationView, LoginView, MeView

urlpatterns = [
    path("auth/login/", LoginView.as_view(), name="login"),
    path("auth/refresh/", AttendanceTokenRefreshView.as_view(), name="token_refresh"),
    path("me/", MeView.as_view(), name="me"),
    path("me/current-organization/", CurrentOrganizationView.as_view(), name="current_org"),
]
