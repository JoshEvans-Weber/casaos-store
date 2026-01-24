Vintage Story Custom Server (CasaOS Edition)

This repository contains the custom deployment logic and CasaOS App Store manifest for a hardened, feature-rich Vintage Story server. It bridges the gap between the high-performance base container and the ease-of-use required for a modern homeserver.

Project Architecture

We have modified the original container to include a dual-service management system:

The Game Engine: Running inside a persistent tmux session to allow for interactive console commands.

The Web Terminal: Powered by ttyd, providing a secure, browser-based CLI on port 7681.

Process Management: A custom entrypoint.sh that handles permission switching (gosu), automatic configuration generation, and log tailing.

Source Origins

Base Image: DarkMatterProductions/vintagestory

Custom Image: ghcr.io/joshevans-weber/vintagestory-custom

App Store: JoshEvans-Weber/casaos-store

Features & Support

Current Capabilities

Interactive Console: Type game commands directly into the CasaOS Terminal button.

Custom Login: Secure terminal access via TERMINAL_USER and TERMINAL_PASS.

Auto-Healing: The container stays alive even if the game crashes, allowing you to debug via the console.

Dynamic World Settings: Move speed, hostility, and monthly cycles are exposed as CasaOS variables.

Ongoing Maintenance Plan

To keep this container stable and modern, we will continue to:

Monitor Upstream: Ensure compatibility with new Vintage Story versions (Stable & Unstable).

Refine CLI Logic: Improve the tmux attachment stability to prevent "Inappropriate ioctl" errors.

Expand Metadata: Add more world-generation toggles to the CasaOS UI as they become available in the server API.

Security Patches: Regularly update the ttyd and dotnet dependencies within the build script.

How to Manage the Server

Administration

To Admin: Open the Terminal in CasaOS and log in with your credentials. You are automatically attached to the live game session.

To Reset: Change the WORLD_NAME in settings or delete the contents of /vintagestory/data/Saves.

Logs: View the live server logs directly through the CasaOS "Logs" interface for easy monitoring.

Credits & Acknowledgments

This project is made possible by the incredible work of the following teams:

Aneuclist (Vintage Story Devs): For creating one of the most deep and atmospheric survival games available.

DarkMatterProductions: For the original community Docker implementation that serves as our base.

The Tmux Team: For the terminal multiplexer that keeps our game session alive in the background.

ttyd (Tsai Shu-hung): For the web-to-terminal bridge that powers our browser-based CLI.

Maintained by JoshEvans-Weber
