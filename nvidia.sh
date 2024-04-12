#!/bin/bash

# https://wiki.hyprland.org/Nvidia/

sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1"/' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

echo "MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)" >> /etc/mkinitcpio.conf

mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia.conf
