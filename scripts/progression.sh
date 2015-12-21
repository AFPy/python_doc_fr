#!/bin/bash

printf "=============== ====== ====== ====== ====== ======\n"
printf "                   2.7    3.2    3.3    3.4    3.5\n"
printf -- "--------------- ------ ------ ------ ------ ------\n"
files='tutorial glossary contents copyright about bugs distributing sphinx
installing license install extending using faq distutils reference howto
c-api whatsnew library'

for file in $files
do
    printf "%15s " "$file"
    for version in 2.7 3.2 3.3 3.4 3.5
    do
        if [ -f "$version/$file.po" ]
        then
            translated="$(msgattrib --translated $version/$file.po 2>/dev/null |
                          grep -c ^msgid)"
            total="$(grep -c ^msgid $version/$file.po)"
        else
            translated=0
            total=1
        fi
        printf "%5s%% " "$((100 * $translated / $total))"
    done
    printf "\n"
done
printf "=============== ====== ====== ====== ====== ======\n"
