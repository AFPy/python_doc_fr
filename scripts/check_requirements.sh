#!/bin/sh

need()
{
    if ! command -v "$1" >/dev/null 2>&1
    then
        echo "'$1' command not found, please install it." >&2
        exit 1
    fi
}

while [ -n "$1" ]
do
    need "$1"
    shift
done
