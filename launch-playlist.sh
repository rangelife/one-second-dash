#!/bin/bash

# load keys
. /etc/environment

# tell ifttt
curl https://maker.ifttt.com/trigger/dash-$1/with/key/$IFTTT_MAKER_KEY



if [ "$1" == Sweepy-Gripey ]; then

    player=bedroom
    playlist=spotify:user:rangelife2:playlist:0SMpzciQeLySoYwkmhCDHd
    volume=60
    shuffle=1

elif [ "$1" == Sweepy-Poo-Poo ]; then

    player=spareroom
    playlist=spotify:playlist:6tE5ODrv37riZ2QwsFiJuL
    volume=80
    shuffle=0

elif [ "$1" == Sweepy-Puff-Buff ]; then

    curl http://localhost:3888/scene/Kitchen

    player=kitchen
    playlist=spotify:playlist:3Cuz5dYY5q0z9rzQxWxrB4
    volume=80
    shuffle=1

elif [ "$1" == Sweepy-Poo-Plops ]; then

    curl http://localhost:3888/scene/Kitchen

    player=kitchen
    playlist=spotify:playlist:6wzqRkQFFhLakk0ovplFpr
    volume=80
    shuffle=0

elif [ "$1" == Sweepy-Scrub-Scrub ]; then

    player=livingroom
    playlist=spotify:playlist:4sEDNtIxg3bryGwP24ZoQj
    volume=80
    shuffle=1

else
    echo "UNRECOGNISED BUTTON"
    exit 1
fi



#squeezeplay $player --raw playlist shuffle 1 &
#squeezeplay $player --raw mixer volume 0

squeezeplay $player --raw sync -
squeezeplay $player --raw mixer volume 0
squeezeplay $player --raw playlist shuffle $shuffle


# xmas
# curl http://localhost:3888/scene/xmas
# squeezeplay livingroom spotify:track:5hslUAKq9I9CG2bAulFkHN

squeezeplay $player $playlist

squeezeplay $player --raw playlist index +1
squeezeplay $player --raw mixer volume $volume

# ding dong
alsaplayer -o alsa --quiet ./doorbell.wav

