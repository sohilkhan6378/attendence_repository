from __future__ import annotations

from datetime import datetime

from django.utils import timezone
from rest_framework import mixins, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.core.pagination import DefaultPagination
from apps.core.permissions import IsOrganizationMember, RolePermission
from apps.organization.models import Organization
from apps.users.models import MembershipRole

from .domain import compute_status, summarize_events
from .filters import AttendanceDayFilter
from .models import (
    AttendanceDay,
    AttendanceRequest,
    MISExportJob,
    MISExportKind,
    Policy,
    PunchKind,
    PunchSource,
    Shift,
)
from .serializers import (
    AttendanceDaySerializer,
    AttendanceRequestSerializer,
    DashboardSerializer,
    MISExportJobSerializer,
    PunchSerializer,
)
from .services import approve_request, get_or_create_day, recalculate_day, register_punch, reject_request


class PunchView(APIView):
    permission_classes = [IsOrganizationMember]
    punch_kind: str

    def post(self, request):
        serializer = PunchSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        timestamp = serializer.validated_data["timestamp"]
        org_id = request.headers.get("X-Org-ID")
        day = register_punch(
            organization_id=org_id,
            employee=request.user,
            day_date=timestamp.date(),
            timestamp=timestamp,
            kind=self.punch_kind,
            source=PunchSource.MOBILE,
            payload=serializer.validated_data.get("payload"),
        )
        policy = Policy.objects.filter(organization_id=org_id).first()
        membership = request.user.memberships.filter(organization_id=org_id).first()
        shift_id = membership.shift_id if membership else None
        shift = Shift.objects.filter(organization_id=org_id, id=shift_id).first()
        if policy and shift:
            recalculate_day(day, policy, shift)
        return Response(AttendanceDaySerializer(day).data)


class CheckInView(PunchView):
    punch_kind = PunchKind.CHECKIN


class CheckOutView(PunchView):
    punch_kind = PunchKind.CHECKOUT


class BreakStartView(PunchView):
    punch_kind = PunchKind.BREAK_START


class BreakEndView(PunchView):
    punch_kind = PunchKind.BREAK_END


class TodayView(APIView):
    permission_classes = [IsOrganizationMember]

    def get(self, request):
        org_id = request.headers.get("X-Org-ID")
        tz = Organization.objects.get(id=org_id).timezone
        now = timezone.now()
        day = get_or_create_day(org_id, request.user, now.date())
        policy = Policy.objects.filter(organization_id=org_id).first()
        membership = request.user.memberships.filter(organization_id=org_id).first()
        shift_id = membership.shift_id if membership else None
        shift = Shift.objects.filter(organization_id=org_id, id=shift_id).first()
        copy = "Absent"
        status_chip = "ABSENT"
        total_work = 0
        total_break = 0
        if policy and shift:
            result = compute_status(day, policy, shift)
            status_chip = result.status
            copy = result.copy
            total_work = result.total_work_mins
            total_break = result.total_break_mins
        data = {
            "status_chip": status_chip,
            "copy": copy,
            "check_in": day.check_in,
            "check_out": day.check_out,
            "total_work": f"{total_work // 60:02d}:{total_work % 60:02d}",
            "total_break": f"{total_break // 60:02d}:{total_break % 60:02d}",
            "auto_checkout": day.auto_checkout,
            "timeline": summarize_events(day.events.all()),
        }
        serializer = DashboardSerializer(data)
        return Response(serializer.data)


class AttendanceDayViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = AttendanceDaySerializer
    pagination_class = DefaultPagination
    permission_classes = [IsOrganizationMember]
    filterset_class = AttendanceDayFilter

    def get_queryset(self):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        queryset = AttendanceDay.objects.filter(organization_id=org_id)
        if self.request.user.memberships.filter(organization_id=org_id, role=MembershipRole.EMPLOYEE).exists():
            queryset = queryset.filter(employee=self.request.user)
        return queryset


class AttendanceRequestViewSet(viewsets.ModelViewSet):
    serializer_class = AttendanceRequestSerializer
    permission_classes = [IsOrganizationMember]
    pagination_class = DefaultPagination

    def get_queryset(self):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        queryset = AttendanceRequest.objects.filter(organization_id=org_id)
        membership = self.request.user.memberships.filter(organization_id=org_id).first()
        if membership and membership.role == MembershipRole.EMPLOYEE:
            queryset = queryset.filter(employee=self.request.user)
        return queryset

    def perform_create(self, serializer):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        serializer.save(organization_id=org_id, employee=self.request.user)

    @action(detail=True, methods=["post"], permission_classes=[IsOrganizationMember, RolePermission])
    def approve(self, request, pk=None):
        self.required_roles = [MembershipRole.MANAGER, MembershipRole.ADMIN]
        attendance_request = self.get_object()
        approve_request(attendance_request, request.user, request.data.get("decision_note", "Approved"))
        return Response(self.get_serializer(attendance_request).data)

    @action(detail=True, methods=["post"], permission_classes=[IsOrganizationMember, RolePermission])
    def reject(self, request, pk=None):
        self.required_roles = [MembershipRole.MANAGER, MembershipRole.ADMIN]
        attendance_request = self.get_object()
        reject_request(attendance_request, request.user, request.data.get("decision_note", "Rejected"))
        return Response(self.get_serializer(attendance_request).data)


class MISExportJobViewSet(mixins.CreateModelMixin, mixins.ListModelMixin, viewsets.GenericViewSet):
    serializer_class = MISExportJobSerializer
    permission_classes = [IsOrganizationMember, RolePermission]
    pagination_class = DefaultPagination
    required_roles = [MembershipRole.ADMIN, MembershipRole.MANAGER]

    def get_queryset(self):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        return MISExportJob.objects.filter(organization_id=org_id)

    def perform_create(self, serializer):  # type: ignore[override]
        org_id = self.request.headers.get("X-Org-ID")
        serializer.save(organization_id=org_id, created_by=self.request.user, status="QUEUED")
