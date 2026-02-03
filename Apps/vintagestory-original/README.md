# Vintage Story Server - Original (Unmodified)

This is the **original unmodified** DarkMatterProductions (https://github.com/DarkMatterProductions/vintagestory) Vintage Story container for comparison testing.

For the enhanced version with web console and auto-restart, use **VintageStory (Custom)** instead.

## Quick Start

```bash
docker run -it --rm \
  -p 42420:42420/udp \
  -p 7681:7681/tcp \
  -v vintagestory-data:/vintagestory/data \
  ghcr.io/joshevans-weber/vintagestory-original:latest
```

## Access Your Server

- **Port**: 42420 (UDP)
- **Address**: Your VPS IP

## Support

- **Vintage Story Wiki**: https://wiki.vintagestory.at/
- **Official Forums**: https://www.vintagestory.at/forums/
