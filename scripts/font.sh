#!/bin/bash

source fn.sh

font_list=$1

cat $font_list | while read lst; do

    fnt=$(echo $lst | awk -F '|' '{print $1}')
    tgt=$(echo $lst | awk -F '|' '{print $2}')
    tgt=$(eval "echo $tgt")

    if [ ! -d "${tgt}" ]; then
        mkdir -p ${tgt} || echo "creating the directory as root instead..." && sudo mkdir -p ${tgt}
        echo "${tgt} directory created..."
    fi

    sudo tar -xzf $(echo $PWD)/assets/${fnt}.tar.gz -C ${tgt}/
    echo "uncompressing ${fnt}.tar.gz --> ${tgt}..."

done

echo "rebuilding font cache..."
fc-cache -f
