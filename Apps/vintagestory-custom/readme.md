Vintage Story Custom Server (CasaOS Edition)

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; background-color: #f6f8fa; margin-bottom: 20px;">

This repository contains the custom deployment logic and CasaOS App Store manifest for a hardened, feature-rich Vintage Story server. It bridges the gap between the high-performance base container and the ease-of-use required for a modern homeserver.

</div>

Project Architecture

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; margin-bottom: 20px;">

We have modified the original container to include a dual-service management system:

<ul style="margin-top: 15px; line-height: 1.6;">
<li><strong>The Game Engine:</strong> Running inside a persistent <code>tmux</code> session to allow for interactive console commands.</li>
<li><strong>The Web Terminal:</strong> Powered by <code>ttyd</code>, providing a secure, browser-based CLI on port <code>7681</code>.</li>
<li><strong>Process Management:</strong> A custom <code>entrypoint.sh</code> that handles permission switching (<code>gosu</code>), automatic configuration generation, and log tailing.</li>
</ul>

</div>

Source Origins

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; background-color: #fcfcfc; margin-bottom: 20px;">

<ul style="line-height: 1.6;">
<li><strong>Base Image:</strong> <a href="https://www.google.com/search?q=https://github.com/DarkMatterProductions/vintagestory">DarkMatterProductions/vintagestory</a></li>
<li><strong>Custom Image:</strong> <a href="https://www.google.com/search?q=https://github.com/JoshEvans-Weber/vintagestory-custom">ghcr.io/joshevans-weber/vintagestory-custom</a></li>
<li><strong>App Store:</strong> <a href="https://github.com/JoshEvans-Weber/casaos-store">JoshEvans-Weber/casaos-store</a></li>
</ul>

</div>

Features & Support

Current Capabilities

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; margin-bottom: 20px;">

<ul style="line-height: 1.6;">
<li><strong>Interactive Console:</strong> Type game commands directly into the CasaOS Terminal button.</li>
<li><strong>Custom Login:</strong> Secure terminal access via <code>TERMINAL_USER</code> and <code>TERMINAL_PASS</code>.</li>
<li><strong>Auto-Healing:</strong> The container stays alive even if the game crashes, allowing you to debug via the console.</li>
<li><strong>Dynamic World Settings:</strong> Move speed, hostility, and monthly cycles are exposed as CasaOS variables.</li>
</ul>

</div>

Ongoing Maintenance Plan

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; margin-bottom: 20px;">

To keep this container stable and modern, we will continue to:

<ul style="margin-top: 15px; line-height: 1.6;">
<li><strong>Monitor Upstream:</strong> Ensure compatibility with new Vintage Story versions (Stable & Unstable).</li>
<li><strong>Refine CLI Logic:</strong> Improve the <code>tmux</code> attachment stability to prevent "Inappropriate ioctl" errors.</li>
<li><strong>Expand Metadata:</strong> Add more world-generation toggles to the CasaOS UI as they become available in the server API.</li>
<li><strong>Security Patches:</strong> Regularly update the <code>ttyd</code> and <code>dotnet</code> dependencies within the build script.</li>
</ul>

</div>

How to Manage the Server

Administration

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; background-color: #f9f9f9; margin-bottom: 20px;">

<ol style="line-height: 1.6;">
<li><strong>To Admin:</strong> Open the <strong>Terminal</strong> in CasaOS and log in with your credentials. You are automatically attached to the live game session.</li>
<li><strong>To Reset:</strong> Change the <code>WORLD_NAME</code> in settings or delete the contents of <code>/vintagestory/data/Saves</code>.</li>
<li><strong>Logs:</strong> View the live server logs directly through the CasaOS "Logs" interface for easy monitoring.</li>
</ol>

</div>

Credits & Acknowledgments

<div style="padding: 20px; border: 1px solid #e1e4e8; border-radius: 6px; margin-bottom: 20px;">

This project is made possible by the incredible work of the following teams:

<ul style="margin-top: 15px; line-height: 1.6;">
<li><a href="https://www.vintagestory.at/"><strong>Aneuclist (Vintage Story Devs)</strong></a>: For creating one of the most deep and atmospheric survival games available.</li>
<li><a href="https://www.google.com/search?q=https://github.com/DarkMatterProductions"><strong>DarkMatterProductions</strong></a>: For the original community Docker implementation that serves as our base.</li>
<li><a href="https://github.com/tmux/tmux"><strong>The Tmux Team</strong></a>: For the terminal multiplexer that keeps our game session alive in the background.</li>
<li><a href="https://github.com/tsl0922/ttyd"><strong>ttyd (Tsai Shu-hung)</strong></a>: For the web-to-terminal bridge that powers our browser-based CLI.</li>
</ul>

</div>

Maintained by JoshEvans-Weber
