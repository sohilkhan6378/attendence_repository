# Attendance Backend

A production-ready Django + DRF backend for the Attendance Management platform. The service
covers multi-tenant organizations, biometric-aware attendance capture, policy enforcement, and
MIS exports designed for the accompanying Flutter apps.

## Features

- Django 5, DRF, and SimpleJWT authentication with org-scoped permissions
- Attendance policy engine implementing grace, half-day cutoff, and auto-checkout rules
- Celery powered auto-checkout, nightly recomputation, and scheduled MIS exports
- Multi-break support, offline punch idempotency, and Excel export helpers
- Dockerized Postgres + Redis stack and pytest-based automated tests

## Getting Started

### Local development

```bash
python -m venv .venv
source .venv/bin/activate
pip install poetry
poetry install
cp .env.example .env
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### Docker

```bash
docker compose up --build
```

The API will be available at `http://localhost:8000/`. Celery worker and beat containers schedule
policy jobs automatically.

### Sample curl

```bash
curl -X POST http://localhost:8000/api/attendance/punch/checkin/ \
  -H "Authorization: Bearer <token>" \
  -H "X-Org-ID: <org-uuid>" \
  -H "Content-Type: application/json" \
  -d '{"device": "SM-E156B", "geo": {"lat": 12.9, "lng": 77.6}}'
```

See the full API reference at `/api/docs/` once the server is running.
