Vintage Story Custom Server (CasaOS Edition)

This is a high-performance, fully customizable Vintage Story server container. It has been built to expose the "World Creation" screen settings directly into the CasaOS dashboard, allowing for granular control over gameplay, difficulty, and world generation without ever touching a JSON file.

Getting Started

Installation: Click Install from your custom CasaOS store.

Configuration: During the "Custom Install" or later in "Settings," you can adjust the variables listed below.

First Boot: Settings in the World Generation section will only apply if a new world is being created. To reset your world and apply new generation settings, delete the files in your /Saves folder or change the WORLD_NAME.

🛠 Configuration Reference

Server Identity

Variable

Default

Description

SERVER_NAME

Vintage Story Server

The name shown in the server browser.

WORLD_NAME

Vintage Story World

The name of the save file. Changing this triggers a new world.

MAX_CLIENTS

16

Maximum number of simultaneous players.

SERVER_PASSWORD

(Empty)

Leave blank for no password.

Gameplay & Combat

Variable

Valid Inputs

Description

PLAY_STYLE

surviveandbuild, wildernesssurvival, exploration

surviveandbuild: Balanced. wildernesssurvival: Hardcore/Random spawns. exploration: No combat.

WORLDCONFIG_GAME_MODE

survival, creative

Sets the default mode for all players.

WORLDCONFIG_CREATURE_HOSTILITY

aggressive, passive, off

Determines if mobs hunt you, ignore you, or don't exist.

WORLDCONFIG_DEATH_PUNISHMENT

drop, keep

drop: Inventory drops on ground. keep: Inventory stays with player.

ALLOW_PVP

true, false

Enables or disables player-vs-player combat.

Player Stats

Variable

Default

Description

WORLDCONFIG_PLAYER_MOVE_SPEED

1.5

Multiplier for running/walking speed.

WORLDCONFIG_PLAYER_HEALTH_POINTS

15

The base HP of a player.

WORLDCONFIG_PLAYER_LIVES

-1

Number of lives before permanent death. -1 is infinite.

WORLDCONFIG_FOOD_SPOIL_SPEED

1

0.5 is twice as slow, 2.0 is twice as fast.

World & Environment

Variable

Valid Inputs

Description

WORLDCONFIG_TEMPORAL_STORMS

off, sometimes, often, veryoften

Frequency of glitch storms.

WORLDCONFIG_TEMPORAL_RIFTS

visible, invisible, off

Whether rifts appear and drain stability.

WORLDCONFIG_DAYS_PER_MONTH

9

Length of a month. Higher values make seasons last longer.

WORLDCONFIG_HARSH_WINTERS

true, false

Whether winter temperatures kill crops and reduce wildlife.

World Generation (Requires New World)

Variable

Default

Description

WORLD_SEED

(Random)

Specific seed for world generation.

WORLD_SIZE

1024000

Total map size in blocks.

WORLDCONFIG_LANDCOVER

1.0

0.1 (mostly ocean) to 1.0 (all land).

WORLDCONFIG_POLAR_EQUATOR_DISTANCE

50000

Distance between climates. Lower = biomes change faster.

Technical Support

Terminal Access: You can access the game console via the CasaOS terminal to use commands like /op or /kick.

AI Integration: To use the automated admin/NPC features, provide a valid OpenAI API key in the OPENAI_API_KEY field.

Applying Changes: Most changes require a container restart. World generation changes require a fresh save file.
