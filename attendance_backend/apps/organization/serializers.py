from __future__ import annotations

from rest_framework import serializers

from .models import Department, Location, Organization


class OrganizationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ["id", "name", "code", "timezone", "settings", "logo", "domains"]


class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ["id", "organization", "name", "latitude", "longitude", "geo_fence_radius_m"]
        read_only_fields = ["organization"]


class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = ["id", "organization", "name"]
        read_only_fields = ["organization"]
