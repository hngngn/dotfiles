#!/bin/bash

source fn.sh

if pkg_installed yay; then
    echo "aur helper is already installed..."
    exit 0
fi

if [ -d ~/aur_temp ]; then
    echo "~/aur_temp directory exists..."
    rm -rf ~/aur_temp/yay
fi

git clone https://aur.archlinux.org/yay.git ~/aur_temp/yay
cd ~/aur_temp/yay
makepkg ${use_default} -si

if [ $? -eq 0 ]; then
    echo "yay aur helper installed..."
    rm -rf ~/aur_temp
    exit 0
else
    echo "yay installation failed..."
    exit $?
fi
