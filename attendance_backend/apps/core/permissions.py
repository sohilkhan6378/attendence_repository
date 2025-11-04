from __future__ import annotations

from typing import Any

from rest_framework.permissions import BasePermission


class IsOrganizationMember(BasePermission):
    """Ensures the authenticated user belongs to the provided organization."""

    def has_permission(self, request, view) -> bool:  # type: ignore[override]
        org_id = request.headers.get("X-Org-ID")
        return bool(org_id and request.user and request.user.is_authenticated and request.user.memberships.filter(organization_id=org_id).exists())


class RolePermission(BasePermission):
    """Validates the user holds one of the required roles in the organization."""

    role_field = "required_roles"

    def has_permission(self, request, view) -> bool:  # type: ignore[override]
        required = getattr(view, self.role_field, [])
        if not required:
            return True
        org_id = request.headers.get("X-Org-ID")
        if not org_id:
            return False
        return request.user.memberships.filter(organization_id=org_id, role__in=required).exists()
