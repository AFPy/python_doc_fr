#!/usr/bin/env python3

import csv
import polib


def mangle_string(string):
    """mangle rest syntax like :foo:`bar` and *x* so an automatic
    translator won't fsck with them.

    Mangling syntax is easy, it's a base32 encoded, UTF-8, sphinx tag
    prefixed by 'SPX'.
    """
    import re
    from base64 import b32encode

    def repl(match):
        return 'SPX' + b32encode(
            match.group(0).encode('utf-8')).decode().replace('=', 'i')
    sphinx_structs = [r':[a-zA-Z:]+`[^`]+`',
                      r'``[^`]+``',
                      r'\*\*[^*]+\*\*',
                      r'`[^`]+`',
                      r'\*[^* ]+\*']
    for struct in sphinx_structs:
        string = re.sub(struct, repl, string)
    return string


def po2csv(csvfile, pofile, untranslated_only=False, mangle=False):
    po = polib.pofile(pofile)
    if mangle:
        mangle_function = mangle_string
    else:
        mangle_function = lambda x: x
    with open(csvfile, 'w', newline='') as opened_csvfile:
        csvwriter = csv.writer(opened_csvfile)
        for entry in po:
            if untranslated_only is False or entry.msgstr == '':
                csvwriter.writerow(
                    [mangle_function(entry.msgid),
                     entry.msgstr])


def parse_args():
    import argparse
    parser = argparse.ArgumentParser(
        description="Create a CSV file from a PO file.")
    parser.add_argument('pofile')
    parser.add_argument('csvfile')
    parser.add_argument('--mangle', help="Mangle rest syntax so an automatic "
                        "translator won't fsck with them", action='store_true')
    parser.add_argument('--untranslated-only', action='store_true')
    return parser.parse_args()

if __name__ == '__main__':
    po2csv(**vars(parse_args()))
