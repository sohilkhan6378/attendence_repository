from __future__ import annotations

from rest_framework.permissions import BasePermission


class IsSelf(BasePermission):
    def has_object_permission(self, request, view, obj) -> bool:  # type: ignore[override]
        return obj == request.user
