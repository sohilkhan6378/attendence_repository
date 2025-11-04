from __future__ import annotations

from rest_framework import mixins, viewsets

from apps.core.pagination import DefaultPagination
from apps.core.permissions import IsOrganizationMember, RolePermission
from apps.users.models import MembershipRole

from .filters import DepartmentFilter, LocationFilter
from .models import Department, Location, Organization
from .serializers import DepartmentSerializer, LocationSerializer, OrganizationSerializer


class OrganizationViewSet(mixins.ListModelMixin, viewsets.GenericViewSet):
    serializer_class = OrganizationSerializer

    def get_queryset(self):  # type: ignore[override]
        return Organization.objects.filter(memberships__user=self.request.user).distinct()


class LocationViewSet(viewsets.ModelViewSet):
    serializer_class = LocationSerializer
    pagination_class = DefaultPagination
    filterset_class = LocationFilter
    permission_classes = [IsOrganizationMember, RolePermission]
    required_roles = [MembershipRole.ADMIN]

    def get_queryset(self):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        return Location.objects.filter(organization_id=org_id)

    def perform_create(self, serializer):  # type: ignore[override]
        serializer.save(organization_id=self.request.headers.get("X-Org-ID"))


class DepartmentViewSet(viewsets.ModelViewSet):
    serializer_class = DepartmentSerializer
    pagination_class = DefaultPagination
    filterset_class = DepartmentFilter
    permission_classes = [IsOrganizationMember, RolePermission]
    required_roles = [MembershipRole.ADMIN]

    def get_queryset(self):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        return Department.objects.filter(organization_id=org_id)

    def perform_create(self, serializer):  # type: ignore[override]
        serializer.save(organization_id=self.request.headers.get("X-Org-ID"))
