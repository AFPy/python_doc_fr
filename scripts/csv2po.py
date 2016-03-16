#!/usr/bin/env python3

import csv
import polib


def unmangle_string(string):
    """unmangle rest syntax like :foo:`bar` and *x* so an automatic
    translator won't fsck with them.

    Mangling syntax is easy, it's a base32 encoded, UTF-8, sphinx tag
    prefixed by 'SPX'.
    """
    import re
    from base64 import b32decode

    def repl(match):
        found = match.group(0)[3:].replace('i', '=')
        return b32decode(found).decode('utf-8')
    return re.sub('SPX[A-Z0-9i]+', repl, string)


def csv2po(csvfile, pofile, msgid_column=0, msgstr_column=1, unmangle=False):
    if unmangle:
        unmangler = unmangle_string
    else:
        unmangler = lambda x: x
    translations = {}
    with open(csvfile) as opened_csvfile:
        dialect = csv.Sniffer().sniff(opened_csvfile.read())
        opened_csvfile.seek(0)
        reader = csv.reader(opened_csvfile, dialect)
        for line in reader:
            translations[unmangler(line[msgid_column])] = unmangler(
                line[msgstr_column])
    po = polib.pofile(pofile)
    for entry in po:
        if entry.msgstr == "" and entry.msgid in translations:
            entry.msgstr = translations[entry.msgid]
            entry.flags.append('fuzzy')
    po.save()


def parse_args():
    import argparse
    parser = argparse.ArgumentParser(
        description="Find traductions in csv file and merge them to a po file.")
    parser.add_argument('csvfile')
    parser.add_argument('pofile')
    parser.add_argument('--msgid-column', default=0)
    parser.add_argument('--msgstr-column', default=1)
    parser.add_argument('--unmangle', action='store_true',
                        help='Unmangle previously mangled sphinx tags.')
    return parser.parse_args()

if __name__ == '__main__':
    csv2po(**vars(parse_args()))
