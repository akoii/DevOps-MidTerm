# Make the Python version into a variable so that it may be updated easily if / when needed.
ARG pythonVersion=3.10

# Use official Python slim image (Debian-based) for faster builds with pre-compiled wheels
FROM python:${pythonVersion}-slim

# Set environment variables to prevent Python from writing pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Designate the `/app` folder inside the container as the working directory.
WORKDIR /app

# Install system dependencies in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libpq-dev \
    gcc \
    && pip install --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better layer caching
COPY ./requirements.txt /app/

# Install Python dependencies (will use pre-compiled wheels from PyPI)
RUN pip install --no-cache-dir -r requirements.txt \
    && apt-get purge -y --auto-remove gcc

# Copy application files
COPY ./app.py ./config.py ./run.py /app/
COPY ./api/ /app/api/
COPY ./migrations/ /app/migrations/

# Create a non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "run.py"]
