#!/bin/bash

source fn.sh

zsh_path="$HOME/.oh-my-zsh"

if [ -d $zsh_path ]; then
    echo "oh my zsh is already installed..."
    exit 0
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if [ $? -eq 0 ]; then
    echo "oh my zsh installed..."
    exit 0
else
    echo "oh my zsh installation failed..."
    exit $?
fi
