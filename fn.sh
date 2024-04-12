#!/bin/bash

set -e

export use_default="--noconfirm"

is_nvidia() {
    if [ $(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i -c nvidia) -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

pkg_installed() {
    local arg=$1

    if pacman -Qi $arg &>/dev/null; then
        return 0
    else
        return 1
    fi
}

arch_pkg_available() {
    local PkgIn=$1

    if pacman -Si $PkgIn &>/dev/null; then
        return 0
    else
        return 1
    fi
}

aur_pkg_available() {
    local PkgIn=$1

    if yay -Si $PkgIn &>/dev/null; then
        return 0
    else
        return 1
    fi
}

is_me() {
    if [ $USER == "hngngn" ];then
        return 0
    else
        return 1
    fi
}

is_grub() {
    if [ -d "/boot/grub" ];then
        return 0
    else
        return 1
    fi
}