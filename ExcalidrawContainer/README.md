# Excalidraw Full - Collaborative Drawing Application

Excalidraw is a web-based collaborative drawing application that allows multiple users to draw, sketch, and create diagrams in real-time on an infinite canvas.

## Features

- **Real-time Collaboration**: Draw together with others in real-time
- **Infinite Canvas**: Unlimited space to create
- **Rich Drawing Tools**: Shapes, freehand drawing, text, connectors, and more
- **Persistent Storage**: Save drawings to persistent volumes
- **Browser-Based**: Access from any web browser
- **No Account Required**: Create and collaborate without signing up
- **Export Options**: Save as PNG, SVG, or native Excalidraw format

## Quick Start

### Using Docker Compose (Named Volumes)

```bash
docker-compose up -d
```

### Using Bind Mounts (Local Directory)

```bash
docker-compose -f docker-compose.bind-mount.yml up -d
mkdir -p ./data
```

### Access

- **Web Interface**: http://localhost:5080
- **Port**: 5080 (mapped to container port 3000)

## Building the Image

```bash
docker build -t ghcr.io/joshevans-weber/excalidraw:latest .
```

## Push to Registry

```bash
docker push ghcr.io/joshevans-weber/excalidraw:latest
docker push ghcr.io/joshevans-weber/excalidraw:1.0.0
```

## Storage Options

### Named Volume (Recommended)

Automatically managed by Docker, data persists across container restarts:
```yaml
volumes:
  excalidraw-data:
```

### Bind Mount

Map a local directory for direct file system access:
```yaml
volumes:
  - ./data:/config/data
```

## Environment Variables

- `NODE_ENV`: Set to `production` for optimal performance
- `VITE_APP_COLLAB_API_SERVER_URL`: Collaboration server URL (optional)
- `VITE_APP_WS_SERVER_URL`: WebSocket server URL (optional)

## Persistence

All drawings and user data are stored in `/config/data` within the container:
- Named volume: Managed by Docker at `excalidraw-data`
- Bind mount: Stored in `./data/` in the project directory

## Troubleshooting

### Container Won't Start

Check logs:
```bash
docker-compose logs excalidraw
```

### Web Interface Not Loading

Ensure port 5080 is not in use:
```bash
netstat -tulpn | grep 5080
```

### Permission Issues

Fix ownership on bind-mount data:
```bash
docker-compose down
sudo chown -R 1000:1000 ./data
docker-compose up -d
```

## Version

**Excalidraw**: Built from latest main branch
**Image Version**: 1.0.0
**Built**: May 2026
