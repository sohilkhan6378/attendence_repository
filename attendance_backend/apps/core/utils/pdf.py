from __future__ import annotations

try:  # pragma: no cover - optional dependency
    from weasyprint import HTML
except Exception:  # pragma: no cover - fallback when not installed
    HTML = None  # type: ignore


def render_pdf(html: str) -> bytes:
    if HTML is None:
        raise RuntimeError("WeasyPrint not installed")
    return HTML(string=html).write_pdf()
