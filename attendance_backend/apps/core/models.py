from __future__ import annotations

import uuid
from typing import Any

from django.db import models


class TimeStampedModel(models.Model):
    """Abstract base with created/updated timestamps."""

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class OrganizationScopedModel(TimeStampedModel):
    """Abstract model that stores the owning organization id."""

    organization_id = models.UUIDField(db_index=True)

    class Meta:
        abstract = True

    def scope_matches(self, org_id: uuid.UUID) -> bool:
        return uuid.UUID(str(self.organization_id)) == org_id


class SoftDeleteQuerySet(models.QuerySet):
    def alive(self) -> "SoftDeleteQuerySet":
        return self.filter(is_deleted=False)

    def delete(self) -> tuple[int, dict[str, int]]:  # pragma: no cover - used rarely
        return super().update(is_deleted=True), {}


class SoftDeleteModel(TimeStampedModel):
    """Base model adding a soft delete flag."""

    is_deleted = models.BooleanField(default=False)

    objects = SoftDeleteQuerySet.as_manager()

    class Meta:
        abstract = True

    def delete(self, using: str | None = None, keep_parents: bool = False) -> tuple[int, dict[str, int]]:
        self.is_deleted = True
        self.save(update_fields=["is_deleted", "updated_at"])
        return 1, {self.__class__.__name__: 1}
