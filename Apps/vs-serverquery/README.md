# VS Server Query

A lightweight web server that fetches and caches JSON data from multiple URLs with a clean web interface.

## Features

- 🚀 Fast HTTP server built with Python
- 💾 Automatic caching with configurable TTL
- 🌐 Clean, responsive web UI
- 📡 API endpoints for querying multiple servers
- 🔄 Configurable server list via `servers.json`

## Configuration

Configure your servers in the `servers.json` file.

### In CasaOS

1. Open CasaOS terminal/file manager
2. Navigate to `/DATA/AppData/vs-serverquery/`
3. Edit `servers.json` with your desired server URLs
4. Restart the VS Server Query container for changes to take effect

### Format

```json
[
  "http://example.com/api",
  "http://another-server.com/data"
]
```

Default servers if not configured:
```json
[
  "http://vintagetest.minecraftharbor.net:8181/",
  "http://vintage.minecraftharbor.net:8182/"
]
```

## API Endpoints

### Get all servers
```
GET /api.php?action=all
```
Returns cached data from all configured servers.

### Get single server
```
GET /api.php?action=single&url=http://example.com/api
```
Returns cached data from a specific URL.

## Cache

- Cache TTL: 10 seconds
- Cache location: `/app/cache`
- Cached as JSON files with MD5-hashed URLs

## Requirements

- Docker
- 50MB disk space (minimal)
- 128MB RAM (minimal)

## Support

For issues or feature requests, visit: [GitHub Repository](https://github.com/yourusername/query-server)
