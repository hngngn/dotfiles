#!/usr/bin/env bash

# Check release
if [ ! -f /etc/arch-release ]; then
    exit 0
fi

# Check for updates
aur=$(yay -Qua | wc -l)
ofc=$(checkupdates | wc -l)

fpk=0
fpk_disp=""

# Calculate total available updates
upd=$((ofc + aur + fpk))

# Show tooltip
if [ $upd -eq 0 ]; then
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    echo "{\"text\":\"$upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi

# Trigger upgrade
if [ "$1" == "up" ]; then
    kitty --title systemupdate sh -c "yay -Syu $fpk_exup"
fi
