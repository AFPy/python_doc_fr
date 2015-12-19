#!/bin/bash

shopt -s globstar

PYDOCFR_ROOT="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"
GEN="$PYDOCFR_ROOT/gen/"
SCRIPTS="$PYDOCFR_ROOT/scripts/"
PATCHES="$PYDOCFR_ROOT/scripts/patches/"

## This script regenerates the french HTML documentation

if ! type sphinx-build >/dev/null
then
    printf "%s (%s)\n" "Missing sphinx-build" \
           "pip3 install --user -U -r requirements.txt" >&2
    exit 1
fi

if ! [ -d "$GEN/src/" ]
then
    "$scripts"/sync.sh
fi

echo "Compiling po files to mo files"
mkdir -p "$GEN"/mo/fr/LC_MESSAGES/
for PO in "$PYDOCFR_ROOT/3.4/"*.po
do
    PO="$(basename "$PO")"
    MO="${PO%.po}.mo"
    echo "msgfmt $PO to $MO"
    msgfmt "$PYDOCFR_ROOT/3.4/$PO" -o "$GEN/mo/fr/LC_MESSAGES/$MO"
done

echo "Rebuilding local documentation cpython source"
sphinx-build "$GEN/src/Doc" "$PYDOCFR_ROOT/www/3.4/"

echo "Adding header in the doc to advertise the github."
sed -i 's|<body role="document">|\0<div class="body" style="line-height: 25px; width:100%; font-size: 90%; text-align:center"><a href="https://www.github.com/AFPY/python_doc_fr/">Envie d'\''aider à traduire ?</a></div>|' $PYDOCFR_ROOT/www/3.4/**/*.html $PYDOCFR_ROOT/www/3.4/*.html

echo "You may run :"
printf "%s\n" "rsync -az build/ afpy.org:/home/mandark/www/3.4/"
