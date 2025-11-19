# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

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
