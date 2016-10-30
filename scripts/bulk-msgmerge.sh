#!/bin/sh

#
# Merges (or copy if not exists) sphinx pot files into our po hierarchy.
# In other words, msgmerges new sphinx pot files with our po files.
#

POT_PATH="$1"
PO_PATH="$2"

find "$POT_PATH" -name '*.pot' |
    while read -r POT
    do
        PO="$PO_PATH/$(echo "$POT" | sed "s#$POT_PATH##; s#\.pot\$#.po#")"
        mkdir -p "$(dirname "$PO")"
        if [ -f "$PO" ];
        then
            msgmerge --force-po -U "$PO" "$POT"
        else
            msgcat -o "$PO" "$POT"
        fi
    done
