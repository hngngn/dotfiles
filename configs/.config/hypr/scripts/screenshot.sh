#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ]; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

swpy_dir="$HOME/.config/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" >$swpy_dir/config

case $1 in
p) # print all outputs
    grimblast copysave screen $temp_screenshot && swappy -f $temp_screenshot ;;
s) # drag to manually snip an area / click on a window to print it
    grimblast --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
m) # print focused monitor
    grimblast copysave output $temp_screenshot && swappy -f $temp_screenshot ;;
esac

rm "$temp_screenshot"
