# Vintage Story Server - VPS Ready

## Quick Start

After installation, the server will automatically:
1. Create all necessary directories
2. Set correct permissions
3. Start the game server
4. Enable web console access

## Access Your Server

### Game Connection
- **Port**: 42420 (UDP)
- **Address**: Your VPS IP
- In Vintage Story, select "Multiplayer" → "Add Server" → Enter your IP

### Web Console
- **URL**: `http://YOUR_VPS_IP:7681`
- **Username**: `evans`
- **Password**: `camp3rjake`

⚠️ **Change the default password!** See configuration section below.

## First Run

The server takes about 30-90 seconds to initialize on first run while it:
- Creates the world database
- Generates initial world data
- Configures server settings

Check the logs: `docker logs vs-server -f`

## Configuration

### Change Web Console Password

Edit the container environment variables:
```bash
docker stop vs-server
# Edit /DATA/AppData/vintagestory/docker-compose.yml
# Change TERMINAL_USER and TERMINAL_PASS
docker start vs-server
```

### Server Settings

Game settings are in: `/DATA/AppData/vintagestory/data/serverconfig.json`

Edit this file to configure:
- World name
- Max players
- Game mode
- Difficulty
- And more

After editing, restart: `docker restart vs-server`

### Mods

Place mod files in: `/DATA/AppData/vintagestory/data/Mods/`

Then restart the server.

## File Locations

All server data is stored in: `/DATA/AppData/vintagestory/data/`

```
/DATA/AppData/vintagestory/data/
├── Logs/           # Server logs
├── Saves/          # World save files
├── Mods/           # Mod files (.cs, .dll)
├── ModConfig/      # Mod configuration
├── Backups/        # World backups
└── serverconfig.json  # Main server config
```

## Troubleshooting

### Server Won't Start

Check logs:
```bash
docker logs vs-server -f
```

Common issues:
1. **Permission errors**: The container runs as root initially to fix permissions automatically
2. **Port conflicts**: Make sure port 42420 isn't in use
3. **Low memory**: Vintage Story needs at least 2GB RAM

### Can't Connect to Game

1. Check firewall allows UDP port 42420
2. Verify server is running: `docker ps | grep vs-server`
3. Check server logs for errors

### Web Console Not Working

1. Check port 7681 is open
2. Verify ttyd is running: `docker exec vs-server ps aux | grep ttyd`
3. Try accessing from local network first

### Permission Issues (if they occur)

The container should handle permissions automatically, but if you see errors:

```bash
docker stop vs-server
sudo chown -R 1100:1100 /DATA/AppData/vintagestory/data
sudo chmod -R 775 /DATA/AppData/vintagestory/data
docker start vs-server
```

## Useful Commands

```bash
# View logs
docker logs vs-server -f

# Send commands to server console
docker exec vs-server vs-command help
docker exec vs-server vs-command "time"
docker exec vs-server vs-command "status"

# Restart server
docker restart vs-server

# Access server shell
docker exec -it vs-server bash

# Stop server
docker stop vs-server

# Start server
docker start vs-server

# Attach to tmux console directly
docker exec -it vs-server tmux -S /tmp/vs.sock attach -t vs
# (Use Ctrl+B then D to detach)
```

## Backup Your World

```bash
# Stop server first
docker stop vs-server

# Backup the entire data directory
sudo tar -czf vintagestory-backup-$(date +%Y%m%d).tar.gz /DATA/AppData/vintagestory/data/

# Start server
docker start vs-server
```

## Updating

When a new version is released:

```bash
docker pull ghcr.io/joshevans-weber/vintagestory-custom:latest
docker stop vs-server
docker rm vs-server
# Then reinstall from CasaOS store
```

Your world data is safe in `/DATA/AppData/vintagestory/data/`

## Support

- **Vintage Story Wiki**: https://wiki.vintagestory.at/
- **Official Forums**: https://www.vintagestory.at/forums/
- **Container Issues**: https://github.com/JoshEvans-Weber/vintagestory-custom/issues

## Advanced: Custom UID/GID

If you need a different user ID (not 1100):

Edit docker-compose.yml and change:
```yaml
environment:
  - UID_NUMBER=your_uid
  - GID_NUMBER=your_gid
```

The container will create the user/group automatically.
