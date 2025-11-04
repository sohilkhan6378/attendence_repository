from __future__ import annotations

from datetime import datetime, timezone

import pytest

from apps.attendance.models import AttendanceRequest, RequestStatus, RequestType
from apps.attendance.services import approve_request, reject_request
from tests.factories.user_factories import MembershipFactory


@pytest.mark.django_db
def test_request_approval_and_rejection():
    membership = MembershipFactory()
    manager = MembershipFactory(organization=membership.organization)
    request = AttendanceRequest.objects.create(
        organization_id=membership.organization.id,
        employee=membership.user,
        date=datetime.now(timezone.utc).date(),
        type=RequestType.MISSED_CHECKIN,
        reason="Forgot",
    )

    approve_request(request, manager.user, "Approved")
    assert request.status == RequestStatus.APPROVED

    reject_request(request, manager.user, "Nope")
    assert request.status == RequestStatus.REJECTED
