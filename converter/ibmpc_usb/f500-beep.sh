#!/bin/sh
# ./f500-beep.sh [duration]
#
# You may need the following in devfs.rules to allow access as non-root:
# [localrules=10]
#   add path 'hidraw*' mode 0660
DURATION_MS=${1:-150}
DURATION_S=`printf '%.3f' ${DURATION_MS}e-3`

# FIXME: This sets the Kana LED of the next best device,
# which may not be the correct keyboard.
# Unfortunately, we cannot query the device with usbhidctl.
# evdev does not allow setting Kana either.
# So this may have to be rewritten in C (see udev(4)) or we would have to use
# Scroll Lock anyway.
for device in /dev/hidraw*; do
	if usbhidctl -f $device -w "Generic_Desktop:Keyboard.LEDs:Kana=1"; then
		sleep $DURATION_S
		exec usbhidctl -f $device -w "Generic_Desktop:Keyboard.LEDs:Kana=0"
	fi
done

# Fall back to Sox
exec play -n synth $DURATION_S square 50 vol 0.5
