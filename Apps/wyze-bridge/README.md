# Wyze Bridge

WebRTC/RTSP/RTMP/HLS streaming bridge for Wyze cameras with local access.

## Features

- **Local Streaming**: Access Wyze cameras via WebRTC, RTSP, RTMP, or HLS without cloud dependencies
- **Web Interface**: Built-in web UI to manage streams and view cameras
- **Multiple Stream Protocols**: Choose WebRTC for low-latency or RTSP/RTMP for broader compatibility
- **Stream Recording**: Record streams directly from the bridge
- **Persistent Storage**: All configuration and recordings stored on the host

## Supported Cameras

- Wyze Cam v1, v2, v3, v4 (2K)
- Wyze Cam Pan, Pan v2, Pan v3, Pan Pro
- Wyze Cam Outdoor, Outdoor v2
- Wyze Cam Doorbell, Doorbell v2 (2K)
- And more - see [supported list](https://github.com/mrlt8/docker-wyze-bridge#supported-cameras)

## Ports

- **5000/tcp** - Web UI (http://your-ip:5000)
- **8554/tcp** - RTSP stream (rtsp://your-ip:8554)
- **8888/tcp** - Main service
- **8189/udp** - WebRTC/ICE
- **8889/tcp** - WebRTC signaling

## Environment Variables

- `WB_AUTH` - Enable web UI authentication (default: true)
- `WB_PASSWORD` - Web UI password (default: wyzebridge)
- `WB_IP` - Server IP for WebRTC (leave empty for auto-detection)
- `RECORD_ALL` - Record all camera streams (optional)
- `RECORD_PATH` - Recording storage path (default: /media/bridge/recordings)

## Storage

- **Data Path**: `/DATA/AppData/wyze-bridge/`
- **Contents**: Configuration, logs, and recordings

## First Run

1. Install and start the container
2. Access web UI at http://your-ip:5000
3. Log in with username and default password
4. Add your Wyze camera credentials
5. Configure stream protocols as needed

## Documentation

- [Official Repository](https://github.com/mrlt8/docker-wyze-bridge)
- [Wiki](https://github.com/mrlt8/docker-wyze-bridge/wiki)
- [Camera Commands](https://github.com/mrlt8/docker-wyze-bridge/wiki/Camera-Commands)

## Requirements

- Wyze account with API key and API ID (required as of May 2024)
- Get credentials at: https://support.wyze.com/hc/en-us/articles/16129834216731

## Network

⚠️ **Security Note**: Do NOT forward ports to the internet unless you know what you're doing. Use a VPN for remote access.
