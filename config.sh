#!/bin/bash

source fn.sh

config_dir=$(echo $(echo $PWD)/configs)

while read lst; do

    pth=$(echo $lst | awk -F '|' '{print $1}')
    cfg=$(echo $lst | awk -F '|' '{print $2}')
    pkg=$(echo $lst | awk -F '|' '{print $3}')
    pth=$(eval echo $pth)

    while read pkg_chk; do
        if ! pkg_installed $pkg_chk; then
            echo "skipping ${cfg}..."
            continue 2
        fi
    done < <(echo "${pkg}" | xargs -n 1)

    echo "${cfg}" | xargs -n 1 | while read cfg_chk; do
        tgt=$(echo $pth | sed "s+^${HOME}++g")

        if [ ! -d $pth ]; then
            mkdir -p $pth
        fi

        cp -r $config_dir$tgt/$cfg_chk $pth
        echo "config restored ${pth} <-- $config_dir$tgt/$cfg_chk..."
    done

done < <(cut -d '#' -f 1 $1)

if is_nvidia; then
    cp ${config_dir}/.config/hypr/nvidia.conf ${HOME}/.config/hypr/nvidia.conf
    echo -e 'source = ~/.config/hypr/nvidia.conf\n' >>${HOME}/.config/hypr/hyprland.conf
fi

if is_me; then
  sed -i "s/^monitor = ,preferred,auto,auto/monitor = eDP-1, 1920x1080@60, 0x0, 1/g" $HOME/.config/hypr/hyprland.conf
fi
