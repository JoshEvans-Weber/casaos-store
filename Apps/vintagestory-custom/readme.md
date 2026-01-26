# Vintage Story Dedicated Server

A fully containerized Vintage Story dedicated server with **real-time web console access** via ttyd and **RCON protocol support** for remote command execution.

![Docker](https://img.shields.io/badge/Docker-Enabled-blue?logo=docker)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

---

## Features

- Containerized: Complete Docker setup with automated builds and deployments
- Web Console: Real-time server terminal access via HTTP (ttyd)
- Authentication: Secure console access with username/password
- RCON Support: VintageRCon mod for remote command execution
- Full History: 10,000 lines of server log history available in console
- Auto-Reconnect: Persistent RCON connection with keep-alive mechanism
- CasaOS Ready: Pre-configured for CasaOS app store deployment
- Multi-Stage Build: Optimized Docker image with minimal dependencies

---

## Quick Start

### Prerequisites

- Docker & Docker Compose
- Git
- 1GB+ RAM available for the server
- Port availability: `42420/udp`, `42420/tcp`, `7681/tcp`, `8080/tcp`

### Option 1: Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/JoshEvans-Weber/vintagecontainer.git
cd vintagecontainer

# Build and run
docker-compose up -d

# View logs
docker logs -f vs-server
```

### Option 2: Manual Build Script

```bash
# Run the build and deploy script
bash vintagestorybuildanddeployy.sh

# Script options:
bash vintagestorybuildanddeployy.sh --skip-build    # Skip Docker build
bash vintagestorybuildanddeployy.sh --no-cleanup    # Keep temp files
```

### Option 3: Docker CLI

Pull and run the pre-built image directly:

```bash
# Pull the latest image
docker pull ghcr.io/joshevans-weber/vintagestory-custom:latest

# Create data directory
mkdir -p /DATA/AppData/vintagestory/data

# Run the container
docker run -d \
  --name vs-server \
  --restart unless-stopped \
  -p 42420:42420/udp \
  -p 42420:42420/tcp \
  -p 7681:7681/tcp \
  -p 8080:8080/tcp \
  -v /DATA/AppData/vintagestory/data:/vintagestory/data \
  -e SERVICE=VintagestoryServer.dll \
  -e UID_NUMBER=1100 \
  -e GID_NUMBER=1100 \
  -e TERMINAL_USER=admin \
  -e TERMINAL_PASS=admin \
  -it \
  ghcr.io/joshevans-weber/vintagestory-custom:latest

# View logs
docker logs -f vs-server
```

### Option 4: Portainer

Using Portainer's web UI:

1. **Login to Portainer** and navigate to your environment
2. **Go to Containers → Add Container**
3. **Fill in the form:**
   - **Name**: `vs-server`
   - **Image**: `ghcr.io/joshevans-weber/vintagestory-custom:latest`
   - **Restart Policy**: `Unless stopped`
   - **Port Mappings**:
     - `42420:42420/udp` (Game Server UDP)
     - `42420:42420/tcp` (Game Server TCP)
     - `7681:7681/tcp` (Web Console)
     - `8080:8080/tcp` (RCON)
   - **Volumes** (Bind Mount):
     - Container: `/vintagestory/data`
     - Host: `/DATA/AppData/vintagestory/data`
   - **Environment Variables**:
     - `SERVICE` = `VintagestoryServer.dll`
     - `UID_NUMBER` = `1100`
     - `GID_NUMBER` = `1100`
     - `TERMINAL_USER` = `admin`
     - `TERMINAL_PASS` = `admin`
   - **Advanced Settings**:
     - Check "Interactive & TTY (-it)"
     - Console: `TTY`
4. **Click Deploy Container**
5. **Access web console**: `http://your-ip:7681` (use admin/admin credentials)

---

## Web Console Access

Once the server is running, access the web console at:

```
http://your-server-ip:7681
```

### Default Credentials
- **Username**: `admin`
- **Password**: `admin`

> WARNING: Change these credentials immediately in `docker-compose.yml` environment variables for production!

### Console Features
- Real-time server output with scrollback history
- Command input with full RCON support
- Automatic reconnection on disconnection
- Server performance monitoring

---

## Ports & Networking

| Port | Protocol | Purpose |
|------|----------|---------|
| `42420` | UDP | Vintage Story game server |
| `42420` | TCP | Vintage Story game server |
| `7681` | TCP | ttyd web console |
| `8080` | TCP | RCON server |

---

## Server Commands

Type commands directly into the web console without the leading slash:

```
# View help
help

# Player management
admin add [player_name]
admin remove [player_name]
players list

# Server configuration
serverconfig advertise on
serverconfig whitelistmode off

# World management
save
backup

# Info
players count
world info
```

**Note**: Commands are sent directly to the RCON protocol—slashes are optional.

---

## 🛠️ Configuration

### Server Settings

Edit game settings by modifying files in the mounted volume:

```
/DATA/AppData/vintagestory/data/
├── serverconfig.json       # Main server configuration
├── whitelist.json          # Whitelisted players
├── Logs/
│   └── server-main.log     # Server logs
└── SaveGames/              # World save files
```

### RCON Configuration

The RCON mod is automatically configured with:
- **Port**: 8080
- **Password**: `rcon`
- **Max Connections**: 10
- **Timeout**: 20 seconds

Located at: `/vintagestory/ModConfig/vsrcon.json`

---

## Architecture

```
┌─────────────────────────────────────────┐
│     Vintage Story Dedicated Server      │
│     (VintagestoryServer.dll)            │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  VintageRCon Mod (Port 8080)    │   │
│  │  - Command Handler             │   │
│  │  - Connection Manager          │   │
│  └─────────────────────────────────┘   │
└────────────┬────────────────────────────┘
             │
    ┌────────┴────────────────────────┐
    │                                 │
┌───▼──────────────────┐  ┌──────────▼────────────┐
│  Python RCON Client  │  │  tail -f (Logging)   │
│  (mcrcon library)    │  │  10,000 line buffer  │
│  - Sends commands    │  │  Real-time stream    │
│  - Keep-alive pings  │  │                      │
└───┬──────────────────┘  └──────────┬───────────┘
    │                                │
    └────────────┬───────────────────┘
                 │
         ┌───────▼──────────┐
         │  ttyd Web Server │
         │  (Port 7681)     │
         │  Auth: admin:*** │
         └──────────────────┘
                 │
         ┌───────▼──────────┐
         │   HTTP Browser   │
         │   Web Console    │
         └──────────────────┘
```

---

## Volume Structure

```
/DATA/AppData/vintagestory/data/
├── SaveGames/
│   └── [world-name]/
│       ├── Metadata.json
│       ├── blocks/
│       ├── entities/
│       └── ...
├── Logs/
│   └── server-main.log
├── ModConfig/
│   └── vsrcon.json
├── serverconfig.json
├── whitelist.json
└── ...
```

---

## Troubleshooting

### Issue: Web console not responding

```bash
# Check if container is running
docker ps | grep vs-server

# View logs
docker logs vs-server

# Restart container
docker restart vs-server
```

### Issue: RCON connection fails

1. Verify RCON password matches in `/vintagestory/ModConfig/vsrcon.json`
2. Check server logs for RCON listener startup message
3. Ensure port 8080 is exposed in docker-compose
4. Allow 15+ seconds for server to initialize

### Issue: No console history

1. Ensure `/DATA/AppData/vintagestory/data/Logs/` volume is mounted
2. Check that `server-main.log` file exists
3. Verify tail process is running: `docker exec vs-server ps aux | grep tail`

### Issue: Commands not executing

1. Type without leading slash: `help` (not `/help`)
2. Check web console connection status in stderr logs
3. Verify RCON mod is loaded in server startup logs
4. Try simple commands first: `help`, `players`

---

## Docker Image Details

- **Base Image**: `DarkMatterProductions/vintagestory` (Debian-based)
- **Runtime**: .NET 8.0.23
- **Dependencies**: 
  - ttyd 1.7.7 (web terminal)
  - mcrcon (RCON client library)
  - python3 with select/subprocess support

**Image Size**: ~2.5GB (uncompressed)

---

## CasaOS Integration

This container is available in the CasaOS App Store:

1. Add store: `https://github.com/JoshEvans-Weber/casaos-store/archive/refs/heads/main.zip`
2. Search for "Vintage Story"
3. One-click install with web console pre-configured

---

## Building from Source

### Full Build & Deploy

```bash
# Builds image, pushes to registry, updates CasaOS store
bash vintagestorybuildanddeployy.sh
```

### Skip Docker Build

```bash
# Only update CasaOS store (requires existing image)
bash vintagestorybuildanddeployy.sh --skip-build
```

### Keep Temporary Files

```bash
# Debugging: keep temp_build_ws directory
bash vintagestorybuildanddeployy.sh --no-cleanup
```

---

## Security Considerations

- WARNING: Change default console credentials immediately
- WARNING: Use strong RCON passwords
- WARNING: Restrict network access to trusted IPs
- WARNING: Monitor server logs for suspicious activity
- WARNING: Keep server and mods updated

---

## Environment Variables

Configure via `docker-compose.yml` or `.env`:

```bash
SERVICE=VintagestoryServer.dll
UID_NUMBER=1100
GID_NUMBER=1100
TERMINAL_USER=admin                # Web console username
TERMINAL_PASS=admin                # Web console password
```

---

## Debugging

### Enable Verbose Logging

Add to `entrypoint-wrapper.sh`:
```bash
export LOGLEVEL=DEBUG
```

### Monitor RCON Connection

```bash
docker logs vs-server | grep RCON
docker logs vs-server | grep "\[LOG\]"
```

### Check RCON Connectivity (from host)

```bash
# If mcrcon is installed on host
mcrcon -H localhost -p 8080 -P rcon help
```

---

## File Structure

```
vintagecontainer/
├── README.md                      # This file
├── vintagestorybuildanddeployy.sh # Build & deploy script
├── docker-compose.yml             # Compose configuration (generated)
├── vsrcon.json                    # RCON config template
├── build-original.sh              # Legacy build script
└── .github/
    └── workflows/                 # CI/CD pipelines (optional)
```

---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Credits

This project stands on the shoulders of giants. Special thanks to:

### Base Infrastructure
- **DarkMatterProductions** - Original Vintage Story Docker image and setup
- **Vintage Story Community** - VintageRCon mod development and maintenance

### Development Tools
- **tsl0922** - ttyd (terminal multiplexer via HTTP)
- **Tiiffi** - mcrcon (Python RCON client library)

### Technologies
- **Vintage Story Developers** - The amazing Vintage Story game and server
- **Anego Studios** - Original game development

### References
- [Vintage Story Official](https://www.vintagestory.at/)
- [ttyd GitHub](https://github.com/tsl0922/ttyd)
- [mcrcon GitHub](https://github.com/Tiiffi/mcrcon)
- [VintageRCon Mod](https://mods.vintagestory.at/)

---

## Support

- Email: [Your Contact]
- Issues: [GitHub Issues](https://github.com/JoshEvans-Weber/vintagecontainer/issues)
- Discussions: [GitHub Discussions](https://github.com/JoshEvans-Weber/vintagecontainer/discussions)

---

**Last Updated**: January 26, 2026  
**Maintained By**: Josh Evans  
**Latest Version**: See [Releases](https://github.com/JoshEvans-Weber/vintagecontainer/releases)

---

Made with care for the Vintage Story community
