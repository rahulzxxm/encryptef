# Use a maintained slim image (bullseye instead of buster)
FROM python:3.10-slim-bullseye

# Install system dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gcc libffi-dev musl-dev ffmpeg aria2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy requirements first (better build caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# Copy project files
COPY . .

# Start both gunicorn and your main.py script
CMD gunicorn app:app & python3 main.py
