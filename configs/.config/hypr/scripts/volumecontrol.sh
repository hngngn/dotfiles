#!/usr/bin/env sh

# set device source

while getopts io SetSrc; do
    case $SetSrc in
    i)
        nsink=$(pamixer --list-sources | grep "_input." | head -1 | awk -F '" "' '{print $NF}' | sed 's/"//')
        srce="--default-source"
        dvce="mic"
        ;;
    o)
        nsink=$(pamixer --get-default-sink | grep "_output." | awk -F '" "' '{print $NF}' | sed 's/"//')
        srce=""
        dvce="speaker"
        ;;
    esac
done

# set device action

step="${2:-5}"

case $1 in
i)
    pamixer $srce -i ${step}
    ;;
d)
    pamixer $srce -d ${step}
    ;;
m)
    pamixer $srce -t
    ;;
esac
