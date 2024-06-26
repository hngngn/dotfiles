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

./font.sh lists/_fonts.lst
./theme.sh lists/_themes.lst
./zsh.sh lists/_zsh_plugins.lst
./config.sh lists/_configs.lst
./etc.sh

if is_nvidia && is_grub; then
  sudo ./nvidia.sh
else
  echo "only support grub..."
fi

while read srv; do
  if [[ $(systemctl list-units --all -t service --full --no-legend "${srv}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${srv}.service" ]]; then
    echo "$srv service is already enabled, enjoy..."
  else
    echo "$srv service is not enabled, enabling..."
    sudo systemctl enable ${srv}.service
    if [[ "$srv" != "nvidia-suspend" && "$srv" != "nvidia-hibernate" && "$srv" != "nvidia-resume" ]]; then
      sudo systemctl start ${srv}.service
      echo "$srv service enabled and started..."
    fi
  fi
done < <(cut -d '#' -f 1 lists/_system.lst)

cat <<"EOF"

 _____     ______     __   __     ______
/\  __-.  /\  __ \   /\ "-.\ \   /\  ___\
\ \ \/\ \ \ \ \/\ \  \ \ \-.  \  \ \  __\
 \ \____-  \ \_____\  \ \_\\"\_\  \ \_____\
  \/____/   \/_____/   \/_/ \/_/   \/_____/

EOF
