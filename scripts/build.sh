#!/bin/bash

## This script regenerates the french HTML documentation

shopt -s globstar

PYDOCFR_ROOT="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"
GEN="$PYDOCFR_ROOT/gen/"
SCRIPTS="$PYDOCFR_ROOT/scripts/"
PATCHES="$PYDOCFR_ROOT/scripts/patches/"

VERSION=${1:-3.5}

if ! type sphinx-build >/dev/null
then
    printf "%s (%s)\n" "Missing sphinx-build" \
           "pip3 install --user -U -r requirements.txt" >&2
    exit 1
fi

"$SCRIPTS"/prepare.sh "$VERSION"

echo "Compiling po files to mo files"
mkdir -p "$GEN/$VERSION/mo/fr/LC_MESSAGES/"
for PO in "$PYDOCFR_ROOT/$VERSION"/*.po
do
    PO="$(basename "$PO")"
    MO="${PO%.po}.mo"
    echo "msgfmt $PO to $MO"
    msgfmt "$PYDOCFR_ROOT/$VERSION/$PO" -o "$GEN/$VERSION/mo/fr/LC_MESSAGES/$MO"
done

echo "Rebuilding local documentation"
sphinx-build -A versionswitcher=1 "$GEN/src/Doc" "$PYDOCFR_ROOT/www/$VERSION/"

echo "Adding header in the doc to advertise the github."
sed -i 's|<body role="document"> *$|\0<div class="body" style="padding:0; line-height: 25px; width:100%; font-size: 90%; text-align:center"><a href="https://www.github.com/AFPY/python_doc_fr/">Envie d'\''aider à traduire ?</a></div>|' $PYDOCFR_ROOT/www/$VERSION/**/*.html $PYDOCFR_ROOT/www/$VERSION/*.html

if ! type markdown >/dev/null
then
    printf "%s (%s)\n" 'You need `markdown` to generate index.html' \
           "apt-get install markdown" >&2
else
    markdown $SCRIPTS/index.md | sed '/%s/{
        r /dev/stdin
        d
    }' $SCRIPTS/index.tpl > $PYDOCFR_ROOT/www/index.html
fi

printf "%s...\n" "Preparing zip and tarballs"
(
    cd www
    zip --quiet -r $VERSION.zip $VERSION
    tar czf $VERSION.tar.gz $VERSION
    tar cjf $VERSION.tar.bz2 $VERSION
)

echo "You may run :"
printf "%s\n" "rsync -az www/ afpy.org:/home/mandark/www/"
