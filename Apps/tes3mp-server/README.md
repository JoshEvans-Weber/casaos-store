# TES3MP Server - The Elder Scrolls III: Morrowind Multiplayer

Official TES3MP server for multiplayer Morrowind gameplay.

## Features

- **Multiplayer Morrowind**: Play together with other players
- **Persistent World**: Worlds and saving survive server restarts  
- **OpenMW Based**: Uses the well-maintained OpenMW engine
- **Highly Configurable**: Customize gameplay, difficulty, and server settings
- **Active Community**: Regular updates and support

## Ports

- **Game Server**: 25565/tcp, 25565/udp

## File Access

Server configuration and data stored at:
- `/DATA/AppData/tes3mp-server/data/`

### Server Configuration

Edit the configuration file:
- `/DATA/AppData/tes3mp-server/data/tes3mp-server-default.cfg`

Key settings to customize:
- `hostname` - Your server name
- `port` - Game port (default 25565)
- `maxPlayers` - Maximum concurrent players
- `password` - Optional server password
- Difficulty, magic, and other gameplay settings

### Server Logs

View logs at:
- `/DATA/AppData/tes3mp-server/data/server.log`

## Usage

1. Install from CasaOS app store
2. Configure storage/data paths
3. (Optional) Edit configuration file if needed
4. Start the server
5. Connect from TES3MP client to: `your-server-ip:25565`

## Connecting from TES3MP Client

1. Launch TES3MP client
2. Add server: `your-server-ip:25565`
3. Create/login to your character
4. Play!

## First Run

On first run, the server will create default configuration and data files. You can customize these before starting.

## Resources

- **TES3MP Website**: https://tes3mp.com/
- **GitHub**: https://github.com/TES3MP/openmw-tes3mp
- **OpenMW Project**: https://openmw.org/
- **Docker Image**: https://hub.docker.com/r/tes3mp/server

## Support

For TES3MP-specific issues, visit: https://tes3mp.com/

---

**Image**: Official TES3MP team Docker image
**Version**: 0.8.1
**Updates**: Pulls latest from Docker Hub
