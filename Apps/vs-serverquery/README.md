# VS Server Query

A lightweight web server that fetches and caches JSON data from multiple URLs with a clean web interface.

## Features

- 🚀 Fast HTTP server built with Python
- 💾 Automatic caching with configurable TTL
- 🌐 Clean, responsive web UI
- 📡 API endpoints for querying multiple servers
- 🔄 Configurable server list via `servers.json`

## Configuration

Configure your servers in the `servers.json` file:

```json
[
  "http://example.com/api",
  "http://another-server.com/data"
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
