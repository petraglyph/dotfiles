#!/bin/sh

if [ "${1}" == "pre" ]; then
        # N/A
elif [ "${1}" == "post" ]; then
        xkbcomp $loc/configs/switch-LALT-LCTL.xkb $DISPLAY
fi
