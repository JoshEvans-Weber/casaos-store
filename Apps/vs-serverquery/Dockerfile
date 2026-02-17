FROM python:3.11-slim

WORKDIR /app

# Copy application files
COPY server.py api.py ./
COPY index.html style.css ./

# Copy config file as template
COPY servers.json ./servers.json.default

# Create data directory and symlinks
RUN mkdir -p /app/data && \
    ln -sf /app/data/servers.json /app/servers.json && \
    ln -sf /app/data/cache /app/cache

# Expose port
EXPOSE 8000

# Health check - simple TCP port check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=2 \
    CMD netstat -tlnp 2>/dev/null | grep -q 8000 || exit 1

# Entrypoint script to ensure data directory is initialized
RUN echo '#!/bin/bash\n\
if [ ! -f /app/data/servers.json ]; then\n\
  cp /app/servers.json.default /app/data/servers.json\n\
fi\n\
mkdir -p /app/data/cache\n\
exec python server.py' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
