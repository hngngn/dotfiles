#!/bin/bash

source scripts/fn.sh

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

./scripts/install.sh package.lst
rm package.lst

cat <<"EOF"

 ______     ______     ______     ______   ______     ______     __     __   __     ______   
/\  == \   /\  ___\   /\  ___\   /\__  _\ /\  __ \   /\  == \   /\ \   /\ "-.\ \   /\  ___\  
\ \  __<   \ \  __\   \ \___  \  \/_/\ \/ \ \ \/\ \  \ \  __<   \ \ \  \ \ \-.  \  \ \ \__ \ 
 \ \_\ \_\  \ \_____\  \/\_____\    \ \_\  \ \_____\  \ \_\ \_\  \ \_\  \ \_\\"\_\  \ \_____\
  \/_/ /_/   \/_____/   \/_____/     \/_/   \/_____/   \/_/ /_/   \/_/   \/_/ \/_/   \/_____/

EOF

cp lists/_fonts.lst fonts.lst
cp lists/_zsh_plugins.lst zsh_plugins.lst
cp lists/_configs.lst configs.lst

./scripts/config.sh configs.lst
./scripts/font.sh fonts.lst
./scripts/zsh.sh zsh_plugins.lst

rm font.lst zsh_plugins.lst configs.lst

cat <<"EOF"

 _____     ______     __   __     ______   
/\  __-.  /\  __ \   /\ "-.\ \   /\  ___\  
\ \ \/\ \ \ \ \/\ \  \ \ \-.  \  \ \  __\  
 \ \____-  \ \_____\  \ \_\\"\_\  \ \_____\
  \/____/   \/_____/   \/_/ \/_/   \/_____/

EOF
