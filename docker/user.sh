#!/bin/bash
server_data_dir=$1
echo " "
echo "Received directory $server_data_dir"
echo " "
cd $server_data_dir
if [ ! -f AstroLauncher.exe ]; then
	if [ -z "$LAUNCHER_VER" ]; then
		LAUNCHER_VER=1.8.3.0
	fi
	target_url="https://github.com/ricky-davis/AstroLauncher/releases/download/v"$LAUNCHER_VER"/AstroLauncher.exe"
	wget $target_url
fi
mkdir -p Astro/Saved/Config/WindowsServer

if [ -z "$OWNER_NAME" ]; then
	OWNER_NAME=
fi

if [ -z "$OWNER_GUID" ]; then
	OWNER_GUID=
fi

if [ -z "$SERVER_NAME" ]; then
	SERVER_NAME="Astroneer Dedicated Server"
fi

if [ -z "$SERVER_PASS" ]; then
	SERVER_PASS=
fi
if [ ! -f "$server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini" ]; then
	touch $server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini
fi
if [ ! -f "$server_data_dir/Astro/Saved/Config/WindowsServer/Engine.ini" ]; then
	touch $server_data_dir/Astro/Saved/Config/WindowsServer/Engine.ini
fi
echo " "
echo "Setting INI overrides..."
echo " "
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini "/Script/Astro.AstroServerSettings" "PublicIP" $(curl ifconfig.co/)
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini "/Script/Astro.AstroServerSettings" "ServerName" "$SERVER_NAME"
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini "/Script/Astro.AstroServerSettings" "ServerPassword" "$SERVER_PASS"
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini "/Script/Astro.AstroServerSettings" "OwnerName" "$OWNER_NAME"
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini "/Script/Astro.AstroServerSettings" "OwnerGuid" "$OWNER_GUID"
crudini --del $server_data_dir/Astro/Saved/Config/WindowsServer/Engine.ini "url"
crudini --del $server_data_dir/Astro/Saved/Config/WindowsServer/Engine.ini "URL"
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/Engine.ini "URL" "Port" $SERVER_PORT
crudini --set $server_data_dir/Astro/Saved/Config/WindowsServer/Engine.ini "SystemSettings" "net.AllowEncryption" False
echo "Finished setting INI overrides"
echo " "
sleep 1
xvfb-run wine AstroLauncher.exe
