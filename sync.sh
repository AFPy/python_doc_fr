#!/bin/sh

## This script:
##  - Download cpython
##  - Regenerate pot files
##  - Merge each pot in corresponding po
##  - Eventually commit

if ! type sphinx-build >/dev/null
then
    printf "%s (%s)\n" "Missing sphinx-build" \
           "pip3 install --user -U -r requirements.txt" >&2
    exit 1
fi

if ! [ -d src/ ]
then
    echo "Cloning cpython sources from github"
    git clone https://github.com/python/cpython.git src
fi

echo "Configuring sphinx, in the cpython clone, to run gettext."
rm -fr pot/
(
    cd src
    git clean -dfq
    git checkout -- .
    git pull --ff-only
    git checkout 3.4
    for patch in ../patches/*.patch
    do
        echo "Applying patch $patch"
        git apply "$patch"
    done
    echo "Regenerating pot files."
    sphinx-build -b gettext Doc ../pot
)

echo "Merge each pot file to corresponding po file."
for POT in pot/*
do
    PO="$(basename ${POT%.pot}.po)"
    if [ -f "$PO" ]
    then
        msgmerge -U "$PO" "$POT"
    else
        cp "$POT" "$PO"
    fi
done

(
    git add *.po
    HAS_MOD="$(git status -su | wc -l | awk '{print $1}')"
    if [ $HAS_MOD != 0 ]
    then
        echo "Git add and git commit changed po files."
        git add *.po
        git commit -m 'merge pot files'
    else
        echo "No changes."
    fi
)
