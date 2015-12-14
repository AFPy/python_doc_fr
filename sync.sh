#!/bin/sh

## This script:
##  - Download cpython
##  - Regenerate pot files
##  - Merge each pot in corresponding po
##  - Eventually commit
##  - Regenerate the french HTML documentation

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
    echo "locale_dirs = ['../../mo']" >> Doc/conf.py
    echo "language = 'fr'" >> Doc/conf.py
    echo "Reparsing cpython source"
    echo "Asking sphinx-build to generate pot files."
    sphinx-build -b gettext Doc ../pot
)

echo "Merge each pot file to corresponding po file."
for POT in pot/*
do
    PO="$(basename ${POT%.pot}.po)"
    msgmerge -U $PO $POT
done

echo "Git add and git commit changed po files."
(
    git add *.po
    HAS_MOD="$(git status -su | wc -l | awk '{print $1}')"
    if [ $HAS_MOD != 0 ]
    then
        git commit -a -m 'merge pot files'
    else
        echo "Won't commit, no changes."
    fi
)

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
