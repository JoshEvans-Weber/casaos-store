# VintageStory Dedicated Server (Preview)

Vintage Story 1.22 test release - dedicated server with web console access via ttyd.

## ⚠️ Preview Version

This is a test/preview release of Vintage Story 1.22. Use with caution in production.

## Features

- Dedicated server for Vintage Story 1.22 test release
- Web-based console access (ttyd)
- RCON support for remote commands
- Persistent data storage
- Port mapping for multiplayer

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

## Note

This is the 1.22 preview/test version. For stable versions, use VintageStory app instead.

