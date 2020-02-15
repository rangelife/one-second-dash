#!/bin/bash

# load keys
. /etc/environment

# tell ifttt
curl https://maker.ifttt.com/trigger/dash-$1/with/key/$IFTTT_MAKER_KEY



if [ "$1" == Sweepy-Gripey ]; then
    player=bedroom
    playlist=spotify:user:rangelife2:playlist:0SMpzciQeLySoYwkmhCDHd
    volume=60
elif [ "$1" == Sweepy-Poo-Poo ]; then
    player=spareroom
    playlist=spotify:playlist:6tE5ODrv37riZ2QwsFiJuL
    volume=80
else
    echo "UNRECOGNISED BUTTON"
    exit 1
fi



# bedroom playlist
squeezeplay $player --raw playlist shuffle 1 &
squeezeplay $player --raw mixer volume 0

# xmas
# curl http://localhost:3888/scene/xmas
# squeezeplay livingroom spotify:track:5hslUAKq9I9CG2bAulFkHN

squeezeplay $player $playlist

squeezeplay $player --raw playlist index +1
squeezeplay $player --raw mixer volume $volume

# ding dong
alsaplayer -o alsa --quiet ./doorbell.wav

