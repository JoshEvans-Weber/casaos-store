FROM python:3.11-slim

WORKDIR /app

# Copy application files
COPY server.py api.py ./
COPY index.html style.css ./
COPY servers.json ./
COPY cache ./cache

# Expose port
EXPOSE 8000

# Health check - simple TCP port check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=2 \
    CMD netstat -tlnp 2>/dev/null | grep -q 8000 || exit 1

# Run the server
CMD ["python", "server.py"]
