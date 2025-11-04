from __future__ import annotations

from django.db.models.signals import post_save
from django.dispatch import receiver

from apps.organization.models import Organization

from .models import Membership, User


@receiver(post_save, sender=Membership)
def set_default_org(sender, instance: Membership, created: bool, **kwargs) -> None:
    if created and not instance.user.default_org:
        instance.user.default_org = instance.organization
        instance.user.save(update_fields=["default_org"])
