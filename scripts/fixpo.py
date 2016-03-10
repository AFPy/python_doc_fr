#!/usr/bin/env python3

import re
import polib


def fix_spaces_inside_quotes(text, quote='``'):
    chunks = text.split(quote)
    is_inside_quote = False
    for i, chunk in enumerate(chunks):
        if is_inside_quote:
            chunks[i] = chunk.strip()
        is_inside_quote = not is_inside_quote
    return quote.join(chunks)


def fix_reference(text):
    def repl(match):
        has_left_space = match.group(1) == ' '
        return '{}:{}:`{}`'.format(
            match.group(1) if has_left_space else match.group(1) + ' ',
            match.group(2).strip(),
            match.group(3).strip())
    return re.sub('(.):([^:]*):\s*`([^`]*)`', repl, text)


def fixpo(pofile, only_fuzzy=False):
    po = polib.pofile(pofile)
    for entry in po:
        if only_fuzzy and 'fuzzy' not in entry.flags:
            continue
        if '``' not in entry.msgstr:
            continue
        text = fix_spaces_inside_quotes(entry.msgstr, '``')
        text = fix_spaces_inside_quotes(text, '*')
        entry.msgstr = fix_reference(text)
    po.save()


def parse_args():
    import argparse
    parser = argparse.ArgumentParser(
        description="Fix Google Translate fsckeries in a po file.")
    parser.add_argument('pofile')
    parser.add_argument('--only-fuzzy', action='store_true')
    return parser.parse_args()

if __name__ == '__main__':
    fixpo(**vars(parse_args()))
