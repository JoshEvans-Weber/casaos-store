FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Install game emulators and dependencies
RUN apt-get update && apt-get install -y \
    mgba-qt \
    libfuse2 \
    wget \
    curl \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create persistent ROM and saves directories
RUN mkdir -p /config/roms/gba && \
    mkdir -p /config/roms/gb && \
    mkdir -p /config/roms/gbc && \
    mkdir -p /config/roms/ds && \
    mkdir -p /config/saves && \
    mkdir -p /config/Desktop

# Create desktop shortcuts with proper formatting
RUN cat > /config/Desktop/mGBA.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=mGBA (Game Boy / GBA)
Comment=Play Game Boy, GBC, and GBA games
Exec=mgba-qt
Icon=application-x-executable
Categories=Game;Emulator;
EOF

RUN cat > /config/Desktop/ROMs.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=File Manager
Comment=Browse ROMs and save files
Exec=pcmanfm /config/roms
Icon=folder
Categories=Utility;
EOF

# Make desktop files executable and readable
RUN chmod 755 /config/Desktop/*.desktop && \
    chown abc:abc /config/Desktop/*.desktop

# Create symlinks for binaries to make them easily accessible
RUN ln -sf /usr/games/mgba-qt /usr/bin/mgba-qt && \
    chmod +x /usr/bin/pcmanfm 2>/dev/null || true

# Set proper permissions on directories
RUN chown -R abc:abc /config/roms /config/saves /config/Desktop && \
    chmod -R 755 /config/roms /config/saves /config/Desktop

# Volume for ROMs and saves persistence
VOLUME ["/config/roms", "/config/saves"]

# Expose webtop port
EXPOSE 3000

LABEL maintainer="JoshEvans-Weber" \
      description="Game emulation hub with mGBA emulator"

# Create desktop shortcuts
RUN echo "[Desktop Entry]\n\
Name=OpenHome (ROM Manager)\n\
Comment=Transfer and manage game ROMs\n\
Exec=/usr/local/bin/openhome --no-sandbox\n\
Icon=system-run\n\
Type=Application\n\
Categories=Game;" > /config/Desktop/OpenHome.desktop && \
    echo "[Desktop Entry]\n\
Name=mGBA (Game Boy / GBA)\n\
Comment=Play Game Boy, GBC, and GBA games\n\
Exec=mgba-qt\n\
Icon=application-x-executable\n\
Type=Application\n\
Categories=Game;" > /config/Desktop/mGBA.desktop && \
    echo "[Desktop Entry]\n\
Name=MelonDS (Nintendo DS)\n\
Comment=Play Nintendo DS games\n\
Exec=melonds\n\
Icon=application-x-executable\n\
Type=Application\n\
Categories=Game;" > /config/Desktop/MelonDS.desktop && \
    chmod +x /config/Desktop/*.desktop

# Set proper permissions
RUN chown -R abc:abc /config/roms /config/saves /config/Desktop

# Volume for ROMs and saves persistence
VOLUME ["/config/roms", "/config/saves"]

# Expose webtop port
EXPOSE 3000

LABEL maintainer="JoshEvans-Weber" \
      description="Game emulation hub with mGBA, MelonDS, and OpenHome ROM manager"
