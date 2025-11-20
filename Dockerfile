# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set up locales (required for onnxruntime)
RUN apt-get update && apt-get install -y locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Set the working directory inside the container
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir onnxruntime

# Copy your code
COPY . .

# Expose port
EXPOSE 5100

# Fixed Gunicorn command – NO COMMENTS inside the JSON array
CMD ["gunicorn", \
     "app:app", \
     "--bind", "0.0.0.0:5100", \
     "--workers", "1", \
     "--worker-class", "sync", \
     "--timeout", "1800", \
     "--graceful-timeout", "1800", \
     "--keep-alive", "5", \
     "--log-level", "info"]
