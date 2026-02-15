# VintageStory Dedicated Server

Vintage Story dedicated server with web console access via ttyd.

## Features

- Dedicated server for Vintage Story
- Web-based console access (ttyd)
- RCON support for remote commands
- Persistent data storage
- Port mapping for multiplayer
- Manual DLL updates and inspection

## Ports

- **Game Server**: 42420/udp, 42420/tcp
- **Web Console**: 7681/tcp (admin/admin by default)
- **RCON**: 8080/tcp

## Environment Variables

- `TERMINAL_USER`: Web console username (default: admin)
- `TERMINAL_PASS`: Web console password (default: admin)
- `RCON_PASSWORD`: RCON password (default: rcon)

## Usage

1. Install from CasaOS app store
2. Configure ports and storage
3. Access web console at http://your-ip:7681
4. Use in-game multiplayer to connect to server IP:42420

## File Access

All server files are stored in `/DATA/AppData/vintagestory-custom/`:

### Server Data
- **Path**: `/DATA/AppData/vintagestory-custom/data/`
- Contains: worlds, logs, mod configurations, save data
- Accessible via file manager

### Server Binaries
- **Path**: `/DATA/AppData/vintagestory-custom/binaries/`
- Contains: VintagestoryServer.dll and all runtime dependencies
- Accessible via file manager for inspection and manual updates
- **On image update**: Auto-refreshed with latest binaries

## Manual DLL Updates

To update specific server DLLs:

1. Stop the container via CasaOS
2. Navigate to `/DATA/AppData/vintagestory-custom/binaries/` in file manager
3. Replace or update specific `.dll` files as needed
4. Restart the container
5. New DLLs will be used immediately on next startup

**Note**: If files are deleted, they'll be auto-restored from image defaults on container restart.

## Troubleshooting

- **Check logs**: `/DATA/AppData/vintagestory-custom/data/Logs/server-main.log`
- **Verify binaries**: `/DATA/AppData/vintagestory-custom/binaries/VintagestoryServer.dll` should exist and be non-zero size
- **Reset to defaults**: Delete all files in `binaries/` folder, restart container

