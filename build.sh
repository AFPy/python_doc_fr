#!/bin/bash

shopt -s globstar

## This script regenerates the french HTML documentation

if ! type sphinx-build >/dev/null
then
    printf "%s (%s)\n" "Missing sphinx-build" \
           "pip3 install --user -U -r requirements.txt" >&2
    exit 1
fi

if ! [ -d src/ ]
then
    ./sync.sh
fi

echo "Compiling po files to mo files"
mkdir -p mo/fr/LC_MESSAGES/
for PO in *.po
do
    MO="${PO%.po}.mo"
    echo "msgfmt $PO to $MO"
    msgfmt "$PO" -o "mo/fr/LC_MESSAGES/${MO}"
done

echo "Rebuilding local documentation cpython source"
sphinx-build src/Doc build

echo "Adding header in the doc to advertise the github."
sed -i 's|<body role="document">|\0<div class="body" style="line-height: 25px; width:100%; font-size: 90%; text-align:center"><a href="https://www.github.com/AFPY/python_doc_fr/">Envie d'\''aider à traduire ?</a></div>|' *.html **/*.html

echo "You may run :"
printf "%s\n" "rsync -az build/ afpy.org:/home/mandark/www/3.4/"
