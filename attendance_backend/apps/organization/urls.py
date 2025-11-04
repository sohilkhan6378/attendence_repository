from __future__ import annotations

from rest_framework.routers import DefaultRouter

from .views import DepartmentViewSet, LocationViewSet, OrganizationViewSet

router = DefaultRouter()
router.register(r"organizations", OrganizationViewSet, basename="organization")
router.register(r"admin/locations", LocationViewSet, basename="location")
router.register(r"admin/departments", DepartmentViewSet, basename="department")

urlpatterns = router.urls
