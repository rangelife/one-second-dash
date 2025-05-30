#!/bin/bash -e

# The WiFi SSIDs that your Dash will try to connect to are defined in file "dash_ssids"

# The channel of that SSID that Dash will try to connect to
# You can either choose this at network creation time,
# or determine it afterwards via tcpdump
CHANNEL=1

# The capability field of your WiFi dongle
# You can determine this via `iw phy`
CAP_FIELD="Capabilities: 0x17e"

# cd to directory containing this script
cd $(dirname $(readlink -f $0))

# tcpdump or someone else eventually gives up
# and tears down our monitor interface. Loop to
# recreate it.
# The break allows us to control-C out of this loop.
while true; do
  sudo ./setup_monitor_interface.sh "$CHANNEL" "$CAP_FIELD" 2>&1
  sudo stdbuf -i0 -o0 -e0 ./doorbell.py 2>&1
done
