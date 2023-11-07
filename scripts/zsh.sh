#!/bin/bash

source fn.sh

zsh_list=$1

cat $zsh_list | while read r_plugin; do
    z_plugin=$(echo $r_plugin | awk -F '/' '{print $NF}')
    if [ "${r_plugin:0:4}" == "http" ] && [ ! -d $Zsh_Plugins/$z_plugin ]; then
        sudo git clone $r_plugin $Zsh_Plugins/$z_plugin
    fi
    w_plugin=$(echo $w_plugin ${z_plugin})
done

echo "intalling zsh plugins --> ${w_plugin}"
