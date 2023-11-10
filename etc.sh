#!/bin/bash

source fn.sh

if pkg_installed sddm; then

    if [ ! -d /etc/sddm.conf.d ]; then
        sudo mkdir -p /etc/sddm.conf.d
    fi

    echo "configuring sddm..."
    sudo tar -xzf $(echo $PWD)/assets/sddm-custom-catppuccin.tar.gz -C /usr/share/sddm/themes/
    sudo cp /usr/share/sddm/themes/sddm-custom-catppuccin/kde_settings.conf /etc/sddm.conf.d/
    setfacl -m u:sddm:x /home/${USER}

else
    echo "WARNING: sddm is not installed..."
fi

if pkg_installed nemo-git; then
    gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

    xdg-mime default nemo.desktop inode/directory
    echo "setting" $(xdg-mime query default "inode/directory") "as default file explorer..."
fi
