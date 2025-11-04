FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml poetry.lock* ./
RUN pip install --no-cache-dir poetry && poetry config virtualenvs.create false
RUN poetry install --no-interaction --no-ansi

COPY . .

CMD ["gunicorn", "attendance_backend.wsgi:application", "--bind", "0.0.0.0:8000"]
