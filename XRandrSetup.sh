#!/bin/bash

# This script saves the current XRandr Settings into a
# command to restore those, then changes the setup of the
# displays to have one unique 1920x1080 monitor and two outputs
# that show the same 1280x720 view.
# If something goes wrong, it is restored

SJB="VGA-0"
CONTROL="DVI-0"
REC="HDMI-0"

newModeName="1280x720_60.00"

# Get current xrandr settings
#x=$(xrandr | grep -E " connected")
#IFS=$'\n' y=($x)

# Prepare the xrandr command to reset to current settings should things not work out
#currentSettings="xrandr"
#for n in ${y[*]}; do
#	extra=$(echo $n | sed -e "s/\([A-Z0-9\-]\+\) connected \([0-9]\+x[0-9]\+\)+\([0-9]\+\)+\([0-9]\+\).*/ --output \1 --mode \2 --pos \3x\4/" 2>&1)
#	currentSettings+=$extra
#done

#echo $currentSettings

currentSettings="xrandr --output VGA-0 --mode 1920x1080 --pos 0x0 --output HDMI-0 --mode 1920x1080i --pos 0x0 --output DVI-0 --mode 1920x1080 --pos 0x0"

modeExists=$(xrandr | grep $newModeName)

if [ $? -eq 1 ]; then
	# Create a new mode for the monitor
	xrandr --newmode $newModeName  74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
fi

# Add mode to DVI Port
xrandr --addmode $CONTROL $newModeName

# Start display setup, mirror display 2 & 3, with display 1 unique
xrandr --output $SJB --mode 1920x1080 --output $REC --mode 1280x720 --pos 1920x0 --output $CONTROL --mode 1280x720_60.00 --same-as $REC

# Throw in a Zenity dialog to ask wether to keep the current settings
(
	echo "10" ; sleep 2
	echo "20" ; sleep 2
	echo "30" ; sleep 2
	echo "40" ; sleep 2
	echo "50" ; sleep 2
	echo "60" ; sleep 2
	echo "70" ; sleep 2
	echo "80" ; sleep 2
	echo "90" ; sleep 2
	echo "100"; sleep 2
) | 
zenity --progress \
	--title="Restoring previous settings" \
	--auto-close \
	--text="The previous settings will be automatically restored.\nHit 'cancel' to keep the current settings." \
	-- percentage=0

# Check wether previous settings should be restored
if [ $? = 1 ] ; then
	exit 0
else
	eval $currentSettings
	zenity --info \
		--text="Previous settings are now restored"
fi
