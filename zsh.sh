#!/bin/bash

source fn.sh

zsh_path="$HOME/.oh-my-zsh"
zsh_plugin_path="$zsh_path/custom/plugins"

if [ -d $zsh_path ]; then
    echo "oh my zsh is already installed..."
    rm -rf $zsh_path
fi

if [ -n "$zsh_path" ]; then
    mkdir -p "$zsh_path"
fi

git init --quiet "$zsh_path" && \
cd "$zsh_path" && \
git config core.eol lf && \
git config core.autocrlf false && \
git config fsck.zeroPaddedFilemode ignore && \
git config fetch.fsck.zeroPaddedFilemode ignore && \
git config receive.fsck.zeroPaddedFilemode ignore && \
git config oh-my-zsh.remote origin && \
git config oh-my-zsh.branch "$BRANCH" && \
git remote add origin "$REMOTE" && \
git fetch --depth=1 origin && \
git checkout -b "$BRANCH" "origin/$BRANCH" || {
    [ ! -d "$zsh_path" ] || {
        cd -
        rm -rf "$zsh_path" 2>/dev/null
    }
    echo "git clone of oh-my-zsh repo failed"
    exit 1
}
chsh -s $(which zsh)

while read r_plugin; do
    z_plugin=$(echo $r_plugin | awk -F '/' '{print $NF}')
    if [ "${r_plugin:0:4}" == "http" ] && [ ! -d $zsh_plugin_path/$z_plugin ]; then
        sudo git clone $r_plugin $zsh_plugin_path/$z_plugin
    fi
    w_plugin=$(echo $w_plugin ${z_plugin})
done < <(cut -d '#' -f 1 $1)

echo "intalling zsh plugins --> ${w_plugin}"
