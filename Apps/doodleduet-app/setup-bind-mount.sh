#!/bin/bash
# Setup script for DoodleDuet CasaOS app with bind mounts
# Run this BEFORE deploying the app if using docker-compose.bind-mount.yml

# Create the data directories
mkdir -p /DATA/AppData/doodleduet
mkdir -p /DATA/AppData/redis

# Set proper permissions
chmod 755 /DATA/AppData/doodleduet
chmod 755 /DATA/AppData/redis

echo "Directories created:"
echo "  - /DATA/AppData/doodleduet"
echo "  - /DATA/AppData/redis"
echo ""
echo "To use bind mounts instead of named volumes:"
echo "1. Copy docker-compose.bind-mount.yml over the main docker-compose.yml"
echo "2. Redeploy the app in CasaOS"
