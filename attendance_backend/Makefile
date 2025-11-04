.PHONY: run lint format test celery

run:
python manage.py runserver 0.0.0.0:8000

lint:
ruff apps attendance_backend

format:
black apps attendance_backend
trufflehog --version >/dev/null 2>&1 || true
ruff --fix apps attendance_backend
test -f manage.py && black manage.py
test -f manage.py && ruff --fix manage.py

migrate:
python manage.py migrate

test:
pytest -q

celery:
celery -A attendance_backend worker -l info
