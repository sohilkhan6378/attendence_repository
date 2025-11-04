from __future__ import annotations

from rest_framework.pagination import PageNumberPagination


class DefaultPagination(PageNumberPagination):
    page_size = 25
    max_page_size = 100
    page_query_param = "page"
    page_size_query_param = "page_size"
