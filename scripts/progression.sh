#!/bin/bash

# Usage: progression.sh --update_readme README.rst

if [ z"$1" = z"--update-readme" ]
then
    $0 | sed 's/ \+$//' |
    sed -i '/^=============== =/,/^=============== =/{ /version/{r /dev/stdin
        }; d }' "$2"
    exit 0
fi

printf "=============== ====== ====== ====== ====== ======\n"
printf "        version    2.7    3.2    3.3    3.4    3.5\n"
printf -- "--------------- ------ ------ ------ ------ ------\n"
files='contents copyright about bugs distributing sphinx installing license
install glossary extending using tutorial faq distutils reference howto c-api
whatsnew library'

for file in $files
do
    printf "%15s " "$file"
    for version in 2.7 3.2 3.3 3.4 3.5
    do
        if [ -f "$version/$file.po" ]
        then
            translated="$(
               msgattrib --translated --no-fuzzy $version/$file.po 2>/dev/null |
               grep -c ^msgid)"
            total="$(grep -c ^msgid $version/$file.po)"
            printf "%5s%% " "$((100 * $translated / $total))"
        else
            printf "%6s " "N/A"
        fi
    done
    printf "\n"
done
printf "=============== ====== ====== ====== ====== ======\n"
