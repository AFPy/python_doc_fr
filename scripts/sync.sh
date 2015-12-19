#!/bin/sh

## This script:
##  - Download cpython to gen/src/
##  - Regenerate pot files to gen/pot/
##  - Merge each pot in corresponding po
##  - Eventually commit

VERSIONS="3.2 3.3 3.4 3.5"
PYDOCFR_ROOT="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"
GEN="$PYDOCFR_ROOT/gen/"
SCRIPTS="$PYDOCFR_ROOT/scripts/"
PATCHES="$PYDOCFR_ROOT/scripts/patches/"

if ! [ -d "$GEN/src/" ]
then
    (
        cd "$GEN"
        echo "Cloning cpython sources from github"
        git clone https://github.com/python/cpython.git src
    )
fi

for VERSION in $VERSIONS
do
    if [ "$VERSION" = 3.2 ]
    then
        pip -q install --user -U "sphinx==1.1.3"
        # To have sphinx.ext.refcounting
    else
        pip -q install --user -U "sphinx"
    fi
    GENVER="$GEN/$VERSION"
    echo "Updating cpython sources"
    rm -fr "$GENVER/pot/"
    (
        cd "$GEN/src/"
        git clean -dfq
        git checkout -- .
        git pull --ff-only
        git checkout "$VERSION"
        for patch in "$PATCHES/$VERSION"/*.patch
        do
            echo "Applying patch $patch"
            git apply "$patch"
        done
        printf "%s\n%s\n" "locale_dirs = ['../../mo']" "language = 'fr'" \
               >> Doc/conf.py
        echo "Regenerating pot files."
        sphinx-build -Q -b gettext Doc "$GENVER/pot/"
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
        git add *.*/*.po
        HAS_MOD="$(git status -su | wc -l | awk '{print $1}')"
        if [ $HAS_MOD != 0 ]
        then
            echo "Git add and git commit changed po files."
            git commit -m "$VERSION: merge pot files"
        else
            echo "$VERSION: No changes."
        fi
    )
done
