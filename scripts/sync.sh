#!/bin/sh

## This script:
##  - run xgettext on cpython
##  - Merge each pot in corresponding po
##  - Eventually commit

PYDOCFR_ROOT="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"
GEN="$PYDOCFR_ROOT/gen"
SCRIPTS="$PYDOCFR_ROOT/scripts"

VERSION=${1:-3.5}
GENVER="$GEN/$VERSION"
"$SCRIPTS"/prepare.sh "$VERSION"

(
    cd "$GEN/src/"
    echo "Regenerating pot files."
    sphinx-build -Q -b gettext Doc Doc
    mkdir -p "$GENVER/pot/"
    rm -fr "$GENVER/pot/"
    mv Doc/*.pot "$GENVER/pot/"
)

echo "Merge each pot file to corresponding po file."
for POT in "$GENVER/pot"/*
do
    PO="$(basename ${POT%.pot}.po)"
    if [ -f "$PYDOCFR_ROOT/$VERSION/$PO" ]
    then
        msgmerge -U "$PYDOCFR_ROOT/$VERSION/$PO" "$POT"
    else
        mkdir -p "$PYDOCFR_ROOT/$VERSION/"
        msgcat -o "$PYDOCFR_ROOT/$VERSION/$PO" "$POT"
    fi
done

(
    cd "$PYDOCFR_ROOT"
    git add "$VERSION"/*.po
    HAS_MOD="$(git status -su | wc -l | awk '{print $1}')"
    if [ $HAS_MOD != 0 ]
    then
        echo "Git add and git commit changed po files."
        git commit -m "$VERSION: merge pot files"
    else
        echo "$VERSION: No changes."
    fi
)
