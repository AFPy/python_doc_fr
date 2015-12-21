#!/bin/sh

for file in 3.5/*.po
do
    file="$(basename $file)"
    msgmerge -o 3.4/$file 3.5/$file 3.4/$file
    # msgmerge -U 3.4/$file gen/3.4/pot/${file}t

    # msgmerge -U 3.3/$file 3.4/$file
    # msgmerge -U 3.3/$file gen/3.3/pot/${file}t
    #
    # msgmerge -U 3.2/$file 3.3/$file
    # msgmerge -U 3.2/$file gen/3.2/pot/${file}t
    #
    # msgmerge -U 2.7/$file 3.2/$file
    # msgmerge -U 2.7/$file gen/2.7/pot/${file}t
done
