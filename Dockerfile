
FROM python:3.10-slim-bookworm

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        ffmpeg \
        aria2 \
        qpdf \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------
# Workdir
# ---------------------------------------------------------------
WORKDIR /app

# ---------------------------------------------------------------
# Python dependencies (cached layer)
# ---------------------------------------------------------------
COPY requirements.txt .
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# ---------------------------------------------------------------
# App files
# ---------------------------------------------------------------
COPY . .

# ---------------------------------------------------------------
# Runtime env
# ---------------------------------------------------------------
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# ---------------------------------------------------------------
# Start bot + web (Heroku needs both a bound port & the bot)
# ---------------------------------------------------------------
CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 1 --timeout 120 & python3 main.py
