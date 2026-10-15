# WoW Forever — Classic 1.12 server appliance (CasaOS)

All-in-one World of Warcraft **1.60.1.70338** private server in a single
container: MariaDB, the Battle.net login server, the world server, and a
self-serve **account registration website**. Game data, TLS certificates and
four ruleset realms are baked into the image — one pull, one run.

| Realm | Ruleset        | Port (TCP) |
| ----- | -------------- | ---------- |
| 70    | Trinity (PvE)  | 8085       |
| 71    | PvP            | 8095       |
| 72    | RP             | 8105       |
| 73    | Hardcore       | 8115       |

---

## Before you install — 2 things

### 1. The image is private

This image bundles Blizzard game data, so it can only live in a **private**
registry. Tell Docker who you are once on the CasaOS host:

```bash
sudo docker login ghcr.io          # username: JoshEvans-Weber
# password: a GitHub PAT with the  read:packages  scope
```

Without this the install fails with `manifest unknown` / `unauthorized`.
This is the only extra step the store cannot do for you.

### 2. Set `SERVER_IP`

Open the compose in CasaOS's editor and change:

```yaml
- SERVER_IP=192.168.1.100     # <-- this machine's LAN IP
```

`SERVER_IP` is the address **every WoW client is told to connect to**, and a
container cannot work out the host's own reachable IP, so the container
deliberately refuses to start if it is missing or wrong.

Find it with `hostname -I | awk '{print $1}'`. If you will play over the
internet, use your VPS/public IP or a Tailscale IP — it must be reachable from
the client machines, not just from the server.

Optional: `REALM_IDS` selects which worlds to boot (`all`, or `70`, or `70,73`).
Boot a single realm first if you want the admin side up before the heavier
worlds load.

---

## First boot

1. MariaDB initialises and imports ~1.2 GB of SQL dumps — **a few minutes**.
2. The world server then loads maps/vmaps/mmaps. A **cold load can take up to
   an hour** (it is I/O bound). It is not hung; watch it with
   `sudo docker logs -f wow-forever`.
3. The registration site comes up at `http://<SERVER_IP>:8080/` as soon as
   supervisord starts, usually well before the world is ready.

Data persists in `/DATA/Appdata/wow-forever/mysql`. Back that folder up; the
container itself is disposable.

## Ports

| Host port | Purpose                                     |
| --------- | ------------------------------------------- |
| 8080      | Registration website (HTTP)                 |
| 8081      | Battle.net REST (HTTPS)                     |
| 1119      | Battle.net game port (TCP)                  |
| 8085/8095/8105/8115 | Realm list, one per ruleset (TCP) |

If 8080 is already taken on your CasaOS box, change the **left-hand** number of
`"8080:8080"` and use that port for the registration URL.

---

## Connecting a client

Clients need the **World of Warcraft Classic beta 1.60.1.70338** client
(`_classic_beta_`, `WowB.exe`) — that is the build this server targets.

1. Download the client kit (a public release on this store's repo):
   <https://github.com/JoshEvans-Weber/casaos-store/releases/download/client-kit-v1.0.0/forever-client-kit.zip>
2. Run **`setup-client.bat`** on the client machine. It installs the server's
   CA certificate, adds the hosts entry `trinity.actual.battle.net -> SERVER_IP`,
   copies the launcher next to WoW, and opens the registration page if you have
   no account yet.
3. Later, if the server's IP ever changes, just run **`update-server-ip.bat`**
   and type the new IP (Enter accepts the `127.0.0.1` default).

The server certificate is issued for the hostname `trinity.actual.battle.net`,
so **the hosts entry is required** — there is no IP SAN, and a launcher setting
will not do it for you.

The `CLIENT-SETUP.md` inside the kit covers the manual steps and
troubleshooting.

## Playing over the internet

Nothing in the container needs to change — only the `SERVER_IP` value does.
Expose the ports directly, or front them with a Cloudflare tunnel; see
`REMOTE-ACCESS.md` in the
[forever-lan](https://github.com/JoshEvans-Weber/forever-lan) repository.

## Troubleshooting

- **Container exits immediately:** `SERVER_IP` was not set. Check
  `sudo docker logs wow-forever` for the `FATAL: SERVER_IP is not set` message.
- **Login fails / "cannot connect at server list":** wrong hosts entry, or
  `SERVER_IP` is an address the client cannot reach.
- **TLS errors:** the CA certificate was not installed as *Trusted Root*, or
  the client build is not 1.60.1.70338.
- **Login works but the world never appears:** the realm port is blocked —
  allow 8085/8095/8105/8115 TCP through the firewall on the server.
- **Everything looks fine but nothing loads:** first-boot import plus the cold
  world load take a long time. Be patient and follow the logs.
