#!/bin/bash -e

location=$(pwd)

echo > /etc/init.d/one-second-dash << EOF
#! /bin/sh
# /etc/init.d/noip 

### BEGIN INIT INFO
# Provides:          noip
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Simple script to start a program at boot
# Description:       A simple script from www.stuffaboutcode.com which will start / stop a program a boot / shutdown.
### END INIT INFO

# If you want a command to always run, put it here

# Carry out specific functions when asked to by the system
case "\$1" in
  start)
    echo "Starting noip"
    # run application you want to start
	cd "$location"
	./start.sh
    ;;
  stop)
    echo "Stopping noip"
    # kill application you want to stop
    kill \$(ps -ef | grep 'sudo ./doorbell.py'  | grep -v grep | awk '{print \$2}')
    ;;
  *)
    echo "Usage: /etc/init.d/noip {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

chmod 755 /etc/init.d/one-second-dash

update-rc.d one-second-dash defaults