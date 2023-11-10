#!/bin/bash

source fn.sh

cat <<"EOF"

 __     __   __     ______     ______   ______     __         __         __     __   __     ______   
/\ \   /\ "-.\ \   /\  ___\   /\__  _\ /\  __ \   /\ \       /\ \       /\ \   /\ "-.\ \   /\  ___\  
\ \ \  \ \ \-.  \  \ \___  \  \/_/\ \/ \ \  __ \  \ \ \____  \ \ \____  \ \ \  \ \ \-.  \  \ \ \__ \ 
 \ \_\  \ \_\\"\_\  \/\_____\    \ \_\  \ \_\ \_\  \ \_____\  \ \_____\  \ \_\  \ \_\\"\_\  \ \_____\
  \/_/   \/_/ \/_/   \/_____/     \/_/   \/_/\/_/   \/_____/   \/_____/   \/_/   \/_/ \/_/   \/_____/

EOF

cp lists/_base.lst package.lst

if is_nvidia; then

  echo "nvidia card detected, setup nvidia drivers..."

  cat /usr/lib/modules/*/pkgbase | while read krnl; do
    echo "${krnl}-headers" >>package.lst
  done

  echo -e "nvidia-dkms\nnvidia-utils" >>package.lst
  sed -i "s/^hyprland-git/hyprland-nvidia-git/g" package.lst

else
  echo "nvidia card not detected, skipping nvidia drivers..."
fi

./install.sh package.lst
rm package.lst

cat <<"EOF"

 ______     ______     ______     ______   ______     ______     __     __   __     ______   
/\  == \   /\  ___\   /\  ___\   /\__  _\ /\  __ \   /\  == \   /\ \   /\ "-.\ \   /\  ___\  
\ \  __<   \ \  __\   \ \___  \  \/_/\ \/ \ \ \/\ \  \ \  __<   \ \ \  \ \ \-.  \  \ \ \__ \ 
 \ \_\ \_\  \ \_____\  \/\_____\    \ \_\  \ \_____\  \ \_\ \_\  \ \_\  \ \_\\"\_\  \ \_____\
  \/_/ /_/   \/_____/   \/_____/     \/_/   \/_____/   \/_/ /_/   \/_/   \/_/ \/_/   \/_____/

EOF

cp lists/_configs.lst configs.lst

if is_me; then
  cp configs/.config/hypr/hyprland.conf hyprland.conf

  sed -i "s/^monitor = ,preferred,auto,auto/monitor = eDP-1, 1920x1080@60, 0x0, 1/g" hyprland.conf
  cp -r hyprland.conf ${HOME}/.config/hypr
  rm hyprland.conf
else
  sed -i 's#${HOME}/.config/hypr|animations.conf keybindings.conf windowrules.conf scripts|hyprland#${HOME}/.config/hypr|animations.conf hyprland.conf keybindings.conf windowrules.conf scripts|hyprland#g' configs.lst
  rm .gtkrc-2.0
fi

./font.sh lists/_fonts.lst
./theme.sh lists/_themes.lst
./config.sh configs.lst
./zsh.sh lists/_zsh_plugins.lst
./etc.sh
rm configs.lst

while read srv; do
  if [[ $(systemctl list-units --all -t service --full --no-legend "${srv}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${srv}.service" ]]; then
    echo "$srv service is already enabled, enjoy..."
  else
    echo "$srv service is not running, enabling..."
    sudo systemctl enable ${srv}.service
    sudo systemctl start ${srv}.service
    echo "$srv service enabled, and running..."
  fi
done < <(cut -d '#' -f 1 lists/_system.lst)

cat <<"EOF"

 _____     ______     __   __     ______   
/\  __-.  /\  __ \   /\ "-.\ \   /\  ___\  
\ \ \/\ \ \ \ \/\ \  \ \ \-.  \  \ \  __\  
 \ \____-  \ \_____\  \ \_\\"\_\  \ \_____\
  \/____/   \/_____/   \/_/ \/_/   \/_____/

EOF
