#!/usr/bin/env sh

function get_brightness() {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i) # increase the backlight by 5%
    brightnessctl set +5%
    ;;
d) # decrease the backlight by 5%
    if [[ $(get_brightness) -lt 5 ]]; then
        # avoid 0% brightness
        brightnessctl set 1%
    else
        # decrease the backlight by 5%
        brightnessctl set 5%-
    fi
    ;;
esac
