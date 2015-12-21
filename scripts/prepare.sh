#!/bin/sh

## This script:
##  - Download cpython to gen/src/
##  - Regenerate pot files to gen/pot/

VERSIONS="3.2 3.3 3.4 3.5"
PYDOCFR_ROOT="$(dirname -- "$(dirname -- "$(readlink -f -- "$0")")")"
GEN="$PYDOCFR_ROOT/gen/"
SCRIPTS="$PYDOCFR_ROOT/scripts/"
PATCHES="$PYDOCFR_ROOT/scripts/patches/"
VERSION=${1:-3.5}

if ! [ -d "$GEN/src/" ]
then
    (
        cd "$GEN"
        echo "Cloning cpython sources from github"
        git clone https://github.com/python/cpython.git src
    )
fi

if [ "$VERSION" = 3.2 ]
then
    pip -q install --user -U "sphinx==1.1.3"
    # To have sphinx.ext.refcounting
else
    pip -q install --user -U "sphinx"
fi

GENVER="$GEN/$VERSION"
echo "Updating cpython sources"
(
    cd "$GEN/src/"
    git clean -dfq
    git checkout -- .
    git pull --ff-only
    git checkout "$VERSION"
    for patch in "$PATCHES/$VERSION"/*.patch
    do
        echo "Applying patch $(basename $patch)"
        git apply "$patch"
    done
    printf "%s\n%s\n" "locale_dirs = ['$GEN/$VERSION/mo/']" "language = 'fr'" \
           >> Doc/conf.py
)
