FROM python:3.11.7-slim AS builder

RUN apt-get update && \
    apt-get install -y libpq-dev gcc

# Create the virtual environment
RUN python -m venv /opt/venv

# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install -r requirements.txt

# Operational stage
FROM python:3.11.7-slim
RUN apt-get update && \
    apt-get install -y libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Get the virtual environment from builder stage
COPY --from=builder /opt/venv /opt/venv

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin: $PATH"

EXPOSE 8501
WORKDIR /app
COPY . /app/
CMD ["python", "-m", "streamlit", "run", "app.py", "--server.port", "8501", "--server.address", "0.0.0.0"]