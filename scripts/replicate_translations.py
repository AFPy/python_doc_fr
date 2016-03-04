#!/usr/bin/env python3

"""
Replicate translations from one version to another,
but this generate useless diffs as polib don't store order of metadata:
https://bitbucket.org/izi/polib/issues/72/

And as polib losses the flags / tcomments of obsolete entries:
https://bitbucket.org/izi/polib/issues/71/

Hope they'll fix it.
"""

import glob
import polib
from tqdm import tqdm
from difflib import SequenceMatcher as SM
from fix_style import fix_style


def find_best_match(possibilities, to_find):
    best_match = (0, None)
    for possibility in [possib for possib in possibilities
                        if possib[:5] == to_find[:5]]:
        match = SM(None, possibility, to_find).ratio()
        if match > best_match[0]:
            best_match = (match, possibility)
    if best_match[0] > .9:
        return best_match[1]


def merge_po_files(po_files, fuzzy=False):
    """Find each po file from the current directory, group them by name,
    and replicate known translations from each one to the others.
    """
    """Given a list of po files, replicate known translation from each
    file to the others.
    """
    known_translations = {}
    # Aggregate all known translations
    for po_file in tqdm(po_files, desc="Searching known translations"):
        po_file = polib.pofile(po_file)
        for entry in po_file:
            if 'fuzzy' not in entry.flags and entry.msgstr != '':
                known_translations[entry.msgid] = entry.msgstr
    # Propagate them
    done = 0
    for po_file in tqdm(po_files, desc="Replicating them"):
        po_file = polib.pofile(po_file)
        for entry in po_file:
            if entry.msgid in known_translations:
                entry.msgstr = known_translations[entry.msgid]
            elif fuzzy:
                best_match = find_best_match(list(known_translations.keys()),
                                             entry.msgid)
                if best_match is not None:
                    print("I think\n  {}\n =\n  {}".format(entry.msgid,
                                                           best_match))
                    entry.msgstr = known_translations[best_match]
                    entry.flags.append('fuzzy')
        po_file.save()

if __name__ == '__main__':
    import sys
    merge_po_files(sorted(glob.glob('*.po') + glob.glob('*/*.po')),
                   '--fuzzy' in sys.argv)
    fix_style()
