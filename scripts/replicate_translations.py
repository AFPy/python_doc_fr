#!/usr/bin/env python3

"""
Replicate translations from one version to another,
but this generate useless diffs as polib don't store order of metadata:
https://bitbucket.org/izi/polib/issues/72/

And as polib losses the flags / tcomments of obsolete entries:
https://bitbucket.org/izi/polib/issues/71/

Hope they'll fix it.
"""

import os
import glob
import polib
from collections import defaultdict


def group_by_filename(po_files):
    """
    For each po file in */*.po, aggregate them by directory name, like:

    >>> group_by_filename(['2.7/foo.po', '2.7/bar.po', '3.2/foo.po'])
    [['2.7/bar.po'], ['2.7/foo.po', '3.2/foo.po']]
    """
    po_per_version = defaultdict(list)
    for po_file in po_files:
        po_per_version[os.path.basename(po_file)].append(po_file)
    return sorted(po_per_version.values())


def merge_po_file(po_files):
    """Given a list of po files, replicate known translation from each
    file to the others.
    """
    known_translations = {}
    # Aggregate all known translations
    for po_file in po_files:
        po_file = polib.pofile(po_file)
        for entry in po_file:
            if entry.msgid not in known_translations:
                known_translations[entry.msgid] = entry.msgstr
    # Propagate them
    for po_file in po_files:
        po_file = polib.pofile(po_file)
        for entry in po_file:
            if entry.msgstr == '' and entry.msgid in known_translations:
                entry.msgstr = known_translations[entry.msgid]
        po_file.save()


def merge_po_files():
    """Find each po file from the current directory, group them by name,
    and replicate known translations from each one to the others.
    """
    for po_files in group_by_filename(glob.glob('*/*.po')):
        merge_po_file(po_files)

if __name__ == '__main__':
    merge_po_files()
    print("Don't forget to run ./scripts/fix_style.sh")
