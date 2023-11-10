#!/usr/bin/env sh

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
then
    pkill -x "wlogout"
    exit 0
fi

# set file variables
wLayout="$HOME/.config/wlogout/layout"
wlTmplt="$HOME/.config/wlogout/style.css"

if [ ! -f $wLayout ] || [ ! -f $wlTmplt ] ; then
    echo "ERROR: Config not found..."
    exit 1;
fi

# eval config files
wlStyle=$(envsubst < $wlTmplt)

# launch wlogout
wlogout -b 2 -c 0 -r 0 -m 0 --layout $wLayout --css <(echo "$wlStyle") --protocol layer-shell
