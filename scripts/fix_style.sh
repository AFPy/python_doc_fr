#!/bin/sh

# Fix style of uncommited po files, or all if --all is given.

# The "tac|tac" trick is an equivalent to "sponge" but as tac is in
# coreutils we're avoiding you to install a new packet.  Without
# `tac|tac` or `sponge`, `msgcat` may start to write in the po file
# before having finised to read it, yielding unpredictible behavior.
# (Yep we also can write to another file and mv it, like sed -i does.)


if [ z"$1" = z"--all" ]
then
    for po in */*.po
    do
        echo "$po"
        tac "$po" | tac | msgcat - -o "$po"
    done
else
    for po in $(git status | grep 'modified.*\.po$' | rev | cut -d' ' -f1 | rev)
    do
        echo "$po"
        tac "$po" | tac | msgcat - -o "$po"
    done
fi
