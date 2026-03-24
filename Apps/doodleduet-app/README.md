# DoodleDuet - Collaborative Drawing Application

Real-time collaborative drawing application with Next.js 15, Socket.IO, and Redis.

## Features

- **Real-time Collaboration**: Draw together on an infinite canvas with friends
- **Live Chat**: Text chat while drawing (coming soon)
- **Canvas Controls**: Pan, zoom, and infinite scrolling
- **Drawing Tools**: Multiple brush sizes and colors
- **Room Management**: Create private or public drawing rooms
- **Admin Controls**: Manage rooms, users, and content
- **Persistent Storage**: Redis-backed session and drawing state persistence
- **WebSocket Support**: Real-time synchronization via Socket.IO

## Ports

- **9002/tcp**: Web UI and API

## Storage Options

### Option 1: Named Volumes (Recommended - Default)

The default `docker-compose.yml` uses Docker named volumes:
- Data stored in Docker's managed location
- Auto-created on first deployment
- Works on all systems including CasaOS
- **No manual setup required**

Volume name: `doodleduet_doodleduet-data`

### Option 2: Bind Mount to `/DATA/AppData/doodleduet`

If you want data at a specific path on your host:

1. **Create the directory first** (required):
   ```bash
   mkdir -p /DATA/AppData/doodleduet
   chmod 755 /DATA/AppData/doodleduet
   ```

2. **Use the bind mount docker-compose**:
   - Replace `docker-compose.yml` with `docker-compose.bind-mount.yml`
   - Redeploy the app in CasaOS

This stores Redis and application data at `/DATA/AppData/doodleduet/` on your host machine.

## Getting Started

### Installation in CasaOS

1. Open the CasaOS App Store
2. Search for "DoodleDuet"
3. Click "Install"
4. Wait for the application to start
5. Access the web UI at `http://<casa-ip>:9002`

### Docker Compose

```bash
docker-compose up -d
```

## Configuration

### Environment Variables

The application uses the following environment variables:

- `REDIS_URL`: Redis connection URL (default: `redis://redis:6379`)
- `NODE_ENV`: Environment mode (default: `production`)
- `NEXT_PUBLIC_API_URL`: Frontend API URL (default: `http://localhost:9002`)

### Advanced Configuration

#### Custom REDIS_URL

To use an external Redis instance:

```yaml
environment:
  - REDIS_URL=redis://external-redis:6379
  - REDIS_PASSWORD=your-password
```

#### Port Mapping

To expose on a different port:

```yaml
ports:
  - "8080:9002/tcp"  # Access via http://localhost:8080
```

## Storage and Persistence

- **Redis Data**: Stored in `/DATA/AppData/doodleduet-app/`
- **Persistence**: Redis AOF (Append-Only File) enabled for durability
- **Backup**: Copy the `/DATA/AppData/doodleduet-app/` directory to backup

## Admin Guide

### Accessing Admin Panel

1. Navigate to `http://<casa-ip>:9002/admin`
2. Authenticate with admin credentials
3. Manage rooms, users, and moderation

### Room Management

- **Create Room**: Click "New Room" in the admin panel
- **Delete Room**: Select room and click "Delete"
- **User Kick**: Select user in room and click "Kick"
- **Content Moderation**: Review and remove inappropriate drawings

## Troubleshooting

### Application doesn't start

**Check logs:**
```bash
docker logs doodleduet-app
docker logs doodleduet-redis
```

**Common issues:**
- Redis not running: Check `docker logs doodleduet-redis`
- Port 9002 already in use: Modify port mapping in docker-compose.yml
- Network issues: Ensure containers can communicate on the `doodleduet` network

### Connection issues

- **"Cannot connect to Redis"**: Verify `REDIS_URL` environment variable
- **"WebSocket connection failed"**: Check firewall rules, ensure port 9002 is accessible
- **Performance lag**: Redis may be under load; check `docker stats`

### Data not persisting

1. Check `/DATA/AppData/doodleduet-app/` permissions
2. Verify Redis is writing to `/data` directory
3. Check disk space: `df -h /DATA`

## Performance Tuning

### Redis Optimization

```yaml
command: redis-server --appendonly yes --appendfsync everysec --maxmemory 1gb --maxmemory-policy allkeys-lru
```

- `--appendfsync everysec`: Balance between performance and durability
- `--maxmemory 1gb`: Limit Redis memory usage
- `--maxmemory-policy allkeys-lru`: Eviction policy when max memory reached

### Docker Resource Limits

```yaml
doodleduet-app:
  resources:
    limits:
      cpus: '2'
      memory: 1G
    reservations:
      cpus: '1'
      memory: 512M
```

## Security Notes

### Important

- **Default Credentials**: Change default admin password immediately
- **Network**: Keep application behind a secure network/VPN
- **Updates**: Regularly update Docker image for security patches
- **Backup**: Regularly backup `/DATA/AppData/doodleduet-app/`

### Network Access

Consider using a reverse proxy with authentication:

```nginx
location /doodleduet/ {
  auth_basic "DoodleDuet";
  proxy_pass http://localhost:3000/;
}
```

## Support & Issues

- **GitHub**: https://github.com/aiyuayaan/doodleduet-app
- **Docker Hub**: https://hub.docker.com/r/aiyuayaan/doodleduet-app
- **CasaOS Store**: https://github.com/JoshEvans-Weber/casaos-store

## License

See the [DoodleDuet GitHub repository](https://github.com/aiyuayaan/doodleduet-app) for license information.

## Related Applications

- **Wyze Bridge**: Local WebRTC/RTSP streaming for Wyze cameras
- **VintageStory**: Dedicated game server
- **TES3MP Server**: Multiplayer Elder Scrolls
- **Toontown Realms**: Toontown MMO custom server
