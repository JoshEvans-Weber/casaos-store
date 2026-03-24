#!/bin/bash
# Setup script for DoodleDuet CasaOS app with bind mounts
# Run this BEFORE deploying the app if using docker-compose.bind-mount.yml

# Create the data directory
mkdir -p /DATA/AppData/doodleduet

# Set proper permissions
chmod 755 /DATA/AppData/doodleduet

echo "Directory created: /DATA/AppData/doodleduet"
echo ""
echo "To use bind mounts instead of named volumes:"
echo "1. Copy docker-compose.bind-mount.yml over the main docker-compose.yml"
echo "2. Redeploy the app in CasaOS"
