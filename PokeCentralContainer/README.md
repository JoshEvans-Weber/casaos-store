# PokeCentral - Multi-Emulator Gaming Hub

A browser-accessible game emulation environment featuring mGBA (Game Boy/GBC/GBA) and MelonDS (Nintendo DS) with ROM management via OpenHome.

## Features

- **mGBA Emulator**: Play Game Boy, Game Boy Color, and Game Boy Advance games
- **MelonDS Emulator**: Play Nintendo DS games with high compatibility
- **OpenHome ROM Manager**: Transfer and manage your game collection
- **Web-Based Desktop**: Access via any web browser (XFCE desktop environment)
- **Persistent Storage**: All ROMs, saves, and configurations persist across container restarts
- **Multi-Device Access**: Use from any device on your network
- **CasaOS Integration**: One-click deployment via CasaOS app store

## Quick Start

### Option 1: Named Volumes (Default - Recommended)

```bash
docker-compose up -d
```

This automatically creates Docker volumes for configuration, ROMs, and saves.

Access at: `http://localhost:6080`

### Option 2: Bind Mounts (Specific Host Paths)

First, set up the required directories:
```bash
bash setup-bind-mount.sh
```

Then deploy:
```bash
docker-compose -f docker-compose.bind-mount.yml up -d
```

Bind mounts will be located at:
- `/DATA/AppData/pokecentral/config` - Desktop configuration
- `/DATA/AppData/pokecentral/roms` - Your game files
- `/DATA/AppData/pokecentral/saves` - Game save files

## Directory Structure

### Inside the Container

```
/config/
├── Desktop/
│   ├── OpenHome.desktop
│   ├── mGBA.desktop
│   └── MelonDS.desktop
├── roms/
│   ├── gba/        # Game Boy Advance ROMs
│   ├── gb/         # Game Boy ROMs
│   ├── gbc/        # Game Boy Color ROMs
│   └── ds/         # Nintendo DS ROMs
└── saves/          # Game save files
```

### Accessing Files (Bind Mount)

If using bind mounts, you can access ROMs directly:
```bash
# Copy ROM files to container location
cp /path/to/game.gba /DATA/AppData/pokecentral/roms/gba/

# Access save files from host
ls /DATA/AppData/pokecentral/saves/
```

## Usage

1. **Start the container** via `docker-compose up -d` or CasaOS
2. **Access the web interface** at `http://localhost:6080`
3. **Copy ROMs** into the appropriate folders (`roms/gba/`, `roms/gb/`, etc.)
4. **Use OpenHome** to transfer ROMs via the desktop app
5. **Launch emulators** from the desktop shortcuts
6. **Save files** are automatically stored in `/config/saves/`

## Port Mapping

| Service | Port | Protocol |
|---------|------|----------|
| Web Desktop (XFCE) | 6080 | TCP |

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `PUID` | 1000 | User ID for file permissions |
| `PGID` | 1000 | Group ID for file permissions |
| `TZ` | UTC | Timezone |
| `TITLE` | PokeCentral | Browser window title |
| `CUSTOM_REPOS` | ghcr.io/joshevans-weber | Docker registry |

## Storage Options Comparison

### Named Volumes
- **Pros**: Auto-created, Docker-managed, cleaner file structure
- **Cons**: Files stored in Docker volumes directory, harder to browse from host
- **Use when**: You prefer Docker to manage everything

### Bind Mounts
- **Pros**: Easy host access, direct file browsing, clear path structure
- **Cons**: Requires pre-creating directories, less portable
- **Use when**: You need direct filesystem access or prefer traditional hosting

## Updating

```bash
# Pull the latest image
docker pull ghcr.io/joshevans-weber/pokecentral:latest

# Recreate container
docker-compose down
docker-compose up -d
```

## Building from Source

```bash
# Build locally
docker build -t pokecentral:local .

# Use in docker-compose
# Edit docker-compose.yml, change image to: pokecentral:local
docker-compose up -d
```

## Troubleshooting

### Web interface not loading
- Check container is running: `docker ps | grep pokecentral`
- Check logs: `docker logs pokecentral`
- Try accessing `http://localhost:6080` with correct port

### ROMs not visible in emulators
- Ensure ROMs are in the correct folder (`/config/roms/{gba,gb,gbc,ds}/`)
- Check file permissions: `docker exec pokecentral ls -la /config/roms/`
- Try refreshing the file browser in the emulator

### OpenHome won't start
- Ensure libfuse2 is installed (should be in Dockerfile)
- Check: `docker exec pokecentral openhome --help`
- Try running from terminal instead of desktop shortcut

### Saves not persisting
- Verify volume/mount is correctly configured: `docker inspect pokecentral`
- Ensure save location matches emulator settings
- Check disk space on host

## Games Configuration

### mGBA Settings
mGBA stores configuration in `~/.config/mGBA/`
Within the container, this maps to `/config/.config/mGBA/`

### MelonDS Settings
MelonDS stores configuration and save data in `~/.melonDS/`
Within the container, this maps to `/config/.melonDS/`

## Tips for Kids/Multiple Users

- Desktop shortcuts make it easy to find games
- OpenHome provides a visual ROM manager interface
- Organize ROMs in platform folders (gba/, gb/, gbc/, ds/)
- Saves are automatically managed per game

## Performance Notes

- **RAM**: 512MB shared memory allocated for X11 operations
- **CPU**: Emulators run efficiently on modern CPUs
- **Network**: Webtop performance depends on network latency
- **Storage**: Use SSD for ROM/save storage if possible

## License

This project uses:
- [linuxserver/webtop](https://github.com/linuxserver/docker-webtop) - LGPL
- [mGBA](https://mgba.io/) - MPL 2.0
- [MelonDS](https://melonds.kuribo64.net/) - GPL 3.0
- [OpenHome](https://github.com/andrewbenington/OpenHome) - MIT

Game ROM files are the property of their respective copyright holders. Ensure you have legal rights to use any ROMs.

## Links

- [mGBA Documentation](https://mgba.io/docs/)
- [MelonDS Website](https://melonds.kuribo64.net/)
- [OpenHome GitHub](https://github.com/andrewbenington/OpenHome)
- [CasaOS](https://casaos.io/)
