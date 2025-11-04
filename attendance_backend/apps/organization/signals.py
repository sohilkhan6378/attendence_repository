from __future__ import annotations

from django.db.models.signals import post_save
from django.dispatch import receiver

from apps.users.models import Membership
from .models import Organization


@receiver(post_save, sender=Organization)
def ensure_admin_membership(sender, instance: Organization, created: bool, **kwargs) -> None:
    if created:
        # When an organization is created we expect the creator to attach memberships explicitly.
        # The signal remains for future automation and logging hooks.
        return
