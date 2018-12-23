#!/bin/bash -e
location=$(pwd)
cat startup-script | sed 's/__LOCATION__/'$location > /etc/init.d/one-second-dash
chmod 755 /etc/init.d/one-second-dash
update-rc.d one-second-dash defaults