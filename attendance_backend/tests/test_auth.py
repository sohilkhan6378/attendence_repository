from __future__ import annotations

from django.urls import reverse

from apps.users.models import MembershipRole
from tests.factories.org_factories import OrganizationFactory
from tests.factories.user_factories import MembershipFactory, UserFactory


def test_login_returns_tokens(client, db):
    organization = OrganizationFactory()
    membership = MembershipFactory(organization=organization)
    user = membership.user
    user.set_password("secret123")
    user.save()

    response = client.post(reverse("login"), {"email": user.email, "password": "secret123"})
    assert response.status_code == 200
    assert "tokens" in response.json()


def test_me_endpoint_requires_auth(client, db):
    user = UserFactory()
    client.force_login(user)
    response = client.get(reverse("me"))
    assert response.status_code == 200
