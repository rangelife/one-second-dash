#!/bin/bash

# load keys
. /etc/environment

# tell ifttt
#curl https://maker.ifttt.com/trigger/dash-$1/with/key/$IFTTT_MAKER_KEY



if [ "$1" == Sweepy-VitaCoco ]; then

    slack "Tea please"

elif [ "$1" == Sweepy-Dog-Breath ]; then

    echo

else
    echo "UNRECOGNISED BUTTON"
    exit 1
fi

# ding dong
#alsaplayer -o alsa --quiet ./doorbell.wav

