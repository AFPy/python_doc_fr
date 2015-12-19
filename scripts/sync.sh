#!/bin/sh

## This script:
##  - Download cpython to gen/src/
##  - Regenerate pot files to gen/pot/
##  - Merge each pot in corresponding po
##  - Eventually commit

PYDOCFR_ROOT="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"
GEN="$PYDOCFR_ROOT/gen/"
SCRIPTS="$PYDOCFR_ROOT/scripts/"
PATCHES="$PYDOCFR_ROOT/scripts/patches/"

if ! type sphinx-build >/dev/null
then
    printf "%s (%s)\n" "Missing sphinx-build" \
           "pip3 install --user -U -r scripts/requirements.txt" >&2
    exit 1
fi

if ! [ -d "$GEN/src/" ]
then
    (
        cd "$GEN"
        echo "Cloning cpython sources from github"
        git clone https://github.com/python/cpython.git src
    )
fi

echo "Configuring sphinx, in the cpython clone, to run gettext."
rm -fr "$GEN/pot/"
(
    cd "$GEN/src/"
    git clean -dfq
    git checkout -- .
    git pull --ff-only
    git checkout 3.4
    for patch in "$PATCHES"/*.patch
    do
        echo "Applying patch $patch"
        git apply "$patch"
    done
    echo "Regenerating pot files."
    sphinx-build -b gettext Doc "$GEN/pot/"
)

echo "Merge each pot file to corresponding po file."
for POT in "$GEN/pot"/*
do
    PO="$(basename ${POT%.pot}.po)"
    if [ -f 3.4/"$PO" ]
    then
        msgmerge -U 3.4/"$PO" "$POT"
    else
        cp "$POT" 3.4/"$PO"
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
            cp "$POT" "$PYDOCFR_ROOT/$VERSION/$PO"
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

(
    cd "$PYDOCFR_ROOT"
    git add */*.po
    HAS_MOD="$(git status -su | wc -l | awk '{print $1}')"
    if [ $HAS_MOD != 0 ]
    then
        echo "Git add and git commit changed po files."
        git commit -m 'merge pot files'
    else
        echo "No changes."
    fi
)
