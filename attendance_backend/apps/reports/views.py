from __future__ import annotations

from django.http import HttpResponse
from rest_framework import permissions
from rest_framework.views import APIView

from apps.attendance.exports import company_summary_xlsx, per_employee_xlsx
from apps.core.permissions import IsOrganizationMember

from .serializers import ReportRequestSerializer


class MyReportExportView(APIView):
    permission_classes = [IsOrganizationMember]

    def get(self, request):
        serializer = ReportRequestSerializer(data=request.query_params)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data
        org_id = request.headers.get("X-Org-ID")
        content = per_employee_xlsx(org_id, request.user, data["start"], data["end"])
        response = HttpResponse(content, content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        response["Content-Disposition"] = "attachment; filename=my-attendance.xlsx"
        return response


class AdminReportExportView(APIView):
    permission_classes = [IsOrganizationMember]

    def get(self, request):
        serializer = ReportRequestSerializer(data=request.query_params)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data
        org_id = request.headers.get("X-Org-ID")
        content = company_summary_xlsx(org_id, data["start"], data["end"])
        response = HttpResponse(content, content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        response["Content-Disposition"] = "attachment; filename=company-summary.xlsx"
        return response
