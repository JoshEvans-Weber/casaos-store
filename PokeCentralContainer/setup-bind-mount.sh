#!/bin/bash
# Setup bind mount directories for PokeCentral

mkdir -p /DATA/AppData/pokecentral/config
mkdir -p /DATA/AppData/pokecentral/roms/{gba,gb,gbc,ds}
mkdir -p /DATA/AppData/pokecentral/saves

echo "✓ Created bind mount directories:"
echo "  - /DATA/AppData/pokecentral/config"
echo "  - /DATA/AppData/pokecentral/roms (with subdirs: gba, gb, gbc, ds)"
echo "  - /DATA/AppData/pokecentral/saves"
echo ""
echo "You can now use docker-compose.bind-mount.yml"
