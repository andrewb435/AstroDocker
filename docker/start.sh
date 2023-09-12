#!/bin/bash
sleep 1
if [ -z "$UID" ]; then
	PID=1000
fi

if [ -z "$GID" ]; then
	GID=1000
fi
echo " "
echo "Setting container user 'abc' to UID $UID : GID $GID"
echo " "
usermod -u $UID abc
groupmod -g $GID abc
server_data_dir=/astroneer
echo " "
echo "Taking ownership of $server_data_dir"
echo " "
chown -R $UID:$GID /astroneer
echo " "
echo "Switching to user $UID"
echo " "
exec su abc /home/abc/user.sh -- "$server_data_dir"
