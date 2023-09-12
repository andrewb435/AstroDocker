# Dockerized Astroneer Server with AstroLauncher #
This is a docker container build on Debian 12 (bookworm) with [Wine](https://www.winehq.org/) and the superb work of Ricky Davis' [AstroLauncher](https://github.com/ricky-davis/AstroLauncher) to do the heavy lifting to run an Astroneer dedicated server.

## IMPORTANT NOTE ##
Because of a limitation in Wine's bcrypt implementation, WINE does not provide the full featureset that AstroServer.exe needs to run. The server runs with an Engine.ini option to disable encryption, and *all clients must have this block in their Engine.ini* in order to connect.

%APPDATA%\Local\Astro\Saved\Config\WindowsNoEditor\Engine.ini
```
[SystemSettings]
net.AllowEncryption=False
```

## Docker Compose ##
This has only ever been tested by building and launching with docker compose locally.

### First launch ###
The first launch will download components to build the container, download AstroLauncher, generate some basic config file entries based on ENV, and download the actual AstroServer files. I recommend running it interactively first time to better monitor progress.
```
docker compose up
```
### Regular launches ###
After the built container has been cached on your machine, you should be able to run normally with a detached compose
```
docker compose up -d
```

## Environment Variables ##
| Variable | Default | Description |
| ----------- | ----------- | ----------- |
| UID | Optional: 1000 | This is the user id that the processes inside the container will run as |
| GID | Optional: 1000 | This is the group id that the processes inside the container will run as |
| LAUNCHER_VER | Optional: 1.8.3.0 | Entrypoint will download the version specified here, or fall back to 1.8.3.0 if none is specified |
| SERVER_NAME | Optional: Astroneer Dedicated Server | Server name that is published |
| SERVER_PASS | Optional: password | Server password if you want a private server |
| SERVER_PORT | Default: 7777 | Make sure to change *both* this and the port mappings below |
| OWNER_NAME | Name of the owner from the server panel | This combined with GUID below will allow your owner user to use the ingame control panel for the server. |
| OWNER_GUID | GUID of the owner from the server panel | The easiest way to get both NAME and GUID is to start the server, log in to the server, and copy them from the AstroLauncher panel |

## Ports ##
| Port | Protocol | Purpose |
| -- | -- | -- |
| 5000 | TCP | AstroLauncher Control Panel |
| 7777 | UDP | Astroneer (Default) Game Port |


## Volumes ##
| Volume | Internal Path | Purpose |
| -- | -- | -- |
| ./server | /astroneer | Contains the bulk data files for AstroLauncher and the Astroneer dedicated server |
| ./config | /astroneer/Astro/Saved | Contains config files and savegames generated by Astroneer |