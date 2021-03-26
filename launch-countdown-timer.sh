#!/bin/bash


# load keys
. /etc/environment

# tell ifttt
#curl https://maker.ifttt.com/trigger/dash-$1/with/key/$IFTTT_MAKER_KEY

# toggle reminders
if pgrep henremind; then
    pkill henremind
else
    henremind 20
fi
