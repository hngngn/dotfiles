#!/bin/bash

source fn.sh

zsh_path="/usr/share/oh-my-zsh"
zsh_plugin_path="$zsh_path/custom/plugins"

while read r_plugin; do
    z_plugin=$(echo $r_plugin | awk -F '/' '{print $NF}')
    if [ "${r_plugin:0:4}" == "http" ] && [ ! -d $zsh_plugin_path/$z_plugin ]; then
        sudo git clone $r_plugin $zsh_plugin_path/$z_plugin
    fi
    w_plugin=$(echo $w_plugin ${z_plugin})
done < <(cut -d '#' -f 1 $1)

echo "intalling zsh plugins --> ${w_plugin}"

chsh -s $(which zsh)
