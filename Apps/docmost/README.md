# Docmost

Docmost is a collaborative document management platform that allows teams to create, organize, and share documents with real-time collaboration features.

## Features

- 📝 **Real-time Collaboration** - Collaborate with team members in real-time
- 📚 **Knowledge Base** - Organize and manage your team's knowledge
- 🔐 **Secure** - Self-hosted on your own infrastructure
- 🎨 **Rich Text Editor** - Full-featured document editing
- 👥 **Team Management** - Invite and manage team members
- 🔍 **Full-text Search** - Powerful search capabilities

## Requirements

This container includes:
- **Docmost** - Main application (port 3000)
- **PostgreSQL 18** - Database backend
- **Redis 8** - Cache and real-time features

## Environment Variables

Customize these when installing:
- `APP_URL` - Domain/URL to access Docmost (default: http://localhost:3000)
- `APP_SECRET` - Security secret key (min 32 characters, required for production)
- `DATABASE_URL` - PostgreSQL connection string (default configured)
- `DB_PASSWORD` - Database password for PostgreSQL

## Storage

Data is persisted in `/DATA/Appdata/docmost/` with three directories:
- `storage/` - Application data and uploads
- `db_data/` - PostgreSQL database files
- `redis_data/` - Redis cache data

## Default Credentials

After first launch, navigate to `http://localhost:3000` to set up your workspace and create an admin account.

## Documentation

For more information, visit: https://docmost.com/docs

## Links

- **GitHub**: https://github.com/docmost/docmost
- **Website**: https://docmost.com
