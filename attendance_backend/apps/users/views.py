from __future__ import annotations

from rest_framework import generics, permissions, response, status
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenRefreshView

from apps.core.permissions import IsOrganizationMember

from .models import User
from .serializers import LoginSerializer, TokenSerializer, UserSerializer, build_tokens_for_user


class LoginView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data["user"]
        tokens = build_tokens_for_user(user)
        data = {
            "tokens": tokens,
            "user": UserSerializer(user).data,
        }
        return response.Response(data, status=status.HTTP_200_OK)


class MeView(generics.RetrieveAPIView):
    serializer_class = UserSerializer

    def get_object(self):  # type: ignore[override]
        return self.request.user


class CurrentOrganizationView(APIView):
    permission_classes = [IsOrganizationMember]

    def get(self, request):
        org_id = request.headers.get("X-Org-ID")
        membership = request.user.memberships.filter(organization_id=org_id).first()
        return response.Response({
            "organization": membership.organization_id if membership else None,
            "role": membership.role if membership else None,
        })


class AttendanceTokenRefreshView(TokenRefreshView):
    serializer_class = TokenSerializer  # type: ignore[assignment]
