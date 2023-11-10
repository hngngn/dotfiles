#!/bin/bash

source fn.sh

while read lst; do

    fnt=$(echo $lst | awk -F '|' '{print $1}')
    tgt=$(echo $lst | awk -F '|' '{print $2}')
    tgt=$(eval "echo $tgt")

    if [ -e "$tgt/$(basename $fnt)" ]; then
      echo "$fnt already installed."
    else
        if [ ! -d "${tgt}" ]; then
            mkdir -p ${tgt} || echo "creating the directory as root instead..." && sudo mkdir -p ${tgt}
            echo "${tgt} directory created..."
        fi

        sudo tar -xzf $(echo $PWD)/assets/${fnt}.tar.gz -C ${tgt}/
        echo "uncompressing ${fnt}.tar.gz --> ${tgt}..."
    fi

done < <(cut -d '#' -f 1 $1)
