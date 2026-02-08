# Toontown Realms Server

Toontown Realms is a headless game server container for running a private Toontown server with the Astron Message Director.

## Features

- **Headless Server**: Runs without GUI, optimized for server environments
- **Wine-based**: Runs Windows binaries (offline.exe, astrond.exe) on Linux
- **Astron Message Director**: Enterprise-grade message passing system
- **Data Persistence**: Persistent volumes for databases and configuration
- **Health Checks**: Automatic health monitoring

## Requirements

- 25GB+ disk space for game files
- 4GB+ RAM recommended
- Ports 7198-7199 available

## Ports

- **7198**: Game Server Port
- **7199**: Astron Message Director
- **7197**: Event Logger

## Volumes

- `/app/astron/databases`: Game state database
- `/app/config`: Server configuration files
- `/app/logs`: Server logs

## Environment Variables

- `TZ`: Timezone (default: UTC)
- `PUID`: User ID (default: 1000)
- `PGID`: Group ID (default: 1000)

## Getting Started

1. Create data directories:
   ```bash
   mkdir -p /DATA/AppData/toontown-realms/{astron/databases,config,logs}
   ```

2. Start the container (CasaOS AppStore or docker-compose)

3. Monitor logs:
   ```bash
   docker logs -f toontown-realms-server
   ```

## Configuration

Edit server configuration files in `/DATA/AppData/toontown-realms/config/`

Key files:
- `server.json`: Main server configuration
- `astrond.yml`: Astron Message Director configuration

## Support

For issues and updates, visit: https://github.com/JoshEvans-Weber/vintagecontainer
