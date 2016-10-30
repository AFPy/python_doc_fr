#!/bin/bash

# Usage: progression.sh --update-readme README.rst

if [ z"$1" = z"--update-readme" ]
then
    $0 | sed 's/ \+$//' |
    sed -i '/^====== ====== ======/,/^====== ====== ======/{ /\./{r /dev/stdin
        }; d }' "$2"
    exit 0
fi

echo "====== ====== ======"
printf "   %s " 2.* 3.*
printf "\n"
echo "------ ------ ------"
for version in 2.* 3.*
do
    translated="$(msgcat 3.5/*.po 3.5/*/*.po |
msgattrib --translated --no-fuzzy - |
grep -c '^msgid')"
    total="$(msgcat 3.5/*.po 3.5/*/*.po | grep -c '^msgid')"
    printf "%5s%% " "$((100 * $translated / $total))"
done
printf "\n"
echo "====== ====== ======"
