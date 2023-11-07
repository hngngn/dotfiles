#!/bin/bash

source fn.sh

if ! pkg_installed git; then
    sudo pacman -S git
fi

if ! pkg_installed yay; then
    if [ -d ~/aur_temp ]; then
        echo "~/aur_temp directory exists..."
        rm -rf ~/aur_temp/yay
    fi

    git clone https://aur.archlinux.org/yay.git ~/aur_temp/yay
    cd ~/aur_temp/yay
    makepkg ${use_default} -si

    if [ $? -eq 0 ]; then
        echo "yay aur helper installed..."
        exit 0
    else
        echo "yay installation failed..."
        exit 1
    fi
fi

install_list=$1

cat $install_list | while read pkg; do
    if [ -z $pkg ]; then
        continue
    fi

    if pkg_installed ${pkg}; then
        echo "skipping ${pkg}..."

    elif arch_pkg_available ${pkg}; then
        echo "queueing ${pkg} from arch repo..."
        pkg_arch=$(echo $pkg_arch ${pkg})

    elif aur_pkg_available ${pkg}; then
        echo "queueing ${pkg} from aur..."
        pkg_aur=$(echo $pkg_aur ${pkg})

    else
        echo "error: unknown package ${pkg}..."
    fi
done

if [ $(echo $pkg_arch | wc -w) -gt 0 ]; then
    echo "installing $pkg_arch from arch repo..."
    sudo pacman ${use_default} -S $pkg_arch
fi

if [ $(echo $pkg_aur | wc -w) -gt 0 ]; then
    echo "installing $pkg_aur from aur..."
    yay ${use_default} -S $pkg_aur
fi
