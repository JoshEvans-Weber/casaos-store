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

## 🗂️ Complete File Access

**ENTIRE SERVER DIRECTORY** is accessible on host at:
```
/DATA/AppData/tes3mp-server/
├── tes3mp-server-default.cfg  (main server config)
├── tes3mp-server.cfg          (server configuration)
├── CoreScripts/               (server core scripts)
├── data/                       (game data, saves, logs)
│   ├── server.log
│   ├── saves/
│   └── ...
├── scripts/                    (server scripts)
├── resources/                  (game resources)
└── [all other server files]
```

### Edit Server Configuration

Edit configuration files directly:
- `/DATA/AppData/tes3mp-server/tes3mp-server-default.cfg` - Default config
- `/DATA/AppData/tes3mp-server/tes3mp-server.cfg` - Active server config
- All files in `/DATA/AppData/tes3mp-server/` are fully editable

Key settings to customize:
- `hostname` - Your server name
- `port` - Game port (default 25565)
- `maxPlayers` - Maximum concurrent players
- `password` - Optional server password
- Difficulty, magic, and other gameplay settings

### Access Server Data & Saves

Game saves and world data:
- `/DATA/AppData/tes3mp-server/data/` - All game data
- `/DATA/AppData/tes3mp-server/data/saves/` - World saves
- Edit directly in file manager or terminal

### Access Server Scripts

Server-side scripts:
- `/DATA/AppData/tes3mp-server/scripts/` - Server scripts directory
- Modify scripts to change server behavior
- Some changes require server restart

### Upload Resource Files & Mods

Place custom content:
- `/DATA/AppData/tes3mp-server/resources/` - Game resources
- `/DATA/AppData/tes3mp-server/data/` - Additional data files
- All accessible directly via file manager

### View Server Logs & Debugging

Monitor server activity:
- `/DATA/AppData/tes3mp-server/data/server.log` - Complete server log
- Check for errors, connections, events
- Monitor in real-time or check after restart

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
