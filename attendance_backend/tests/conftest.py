from __future__ import annotations

import pytest
from django.test import Client

from apps.organization.models import Organization


@pytest.fixture
def api_client() -> Client:
    return Client()


@pytest.fixture
def organization(db) -> Organization:
    return Organization.objects.create(name="Test Org", code="test", timezone="Asia/Kolkata")
