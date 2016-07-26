#!/usr/bin/env python3

import re
import sys
import polib


def fix_spaces_inside_quotes(text, quote='``'):
    """
    >>> test = '''\
    :meth:`update` accepte soit un autre objet dictionnaire ou un iterable de\
    paires clé / valeur (comme tuples ou d'autres iterables de longueur deux).\
    Si les arguments de mots clés sont spécifiés, le dictionnaire est alors mis\
    à jour avec ces paires clé / valeur: ``d.update(red=1, blue=2)``.\
    '''
    >>> fixed = fix_spaces_inside_quotes(test, '``')
    >>> ':meth:`update`' in fixed
    True
    >>> fixed = fix_spaces_inside_quotes(test, '*')
    >>> ':meth:`update`' in fixed
    True
    """
    chunks = text.split(quote)
    is_inside_quote = False
    for i, chunk in enumerate(chunks):
        if is_inside_quote:
            chunks[i] = chunk.strip()
        is_inside_quote = not is_inside_quote
    return quote.join(chunks)


def fix_reference(text):
    """
    >>> fix_reference(":ref:`test`")
    ':ref:`test`'
    >>> fix_reference(":ref: `test`")
    ':ref:`test`'
    >>> fix_reference("   :meth:`update`   ")
    '   :meth:`update`   '
    >>> fix_reference("   :meth:`update`, et: ``foo``")
    '   :meth:`update`, et: ``foo``'
    >>> fix_reference(":meth:`update` : ``d.update(red=1, blue=2)``.")
    ':meth:`update` : ``d.update(red=1, blue=2)``.'
    """
    def repl(match):
        suffix = ' ' if match.group(1) != ' ' and match.group(1) != '' else ''
        return '{}:{}:`{}`'.format(
            match.group(1) + suffix,
            match.group(2).strip(),
            match.group(3).strip())
    find = r'(.|^):([^:\`]*):\s*`([^`]*)`'
    return re.sub(find, repl, text)


def fixpo(pofile, only_fuzzy=False, doctest=None):
    po = polib.pofile(pofile)
    for entry in po:
        if only_fuzzy and 'fuzzy' not in entry.flags:
            continue
        if '``' not in entry.msgstr:
            continue
        text = fix_spaces_inside_quotes(entry.msgstr, '``')
        text = fix_spaces_inside_quotes(text, '*')
        text = fix_reference(text)
        if ':meth:`update`' in entry.msgstr:
            if ':meth:`update`' not in text:
                print(entry, repr(fix_bad_translations(fix_spaces_inside_quotes(fix_spaces_inside_quotes(entry.msgstr, '``'), '*'))))
        entry.msgstr = text
    po.save()


def parse_args():
    import argparse
    parser = argparse.ArgumentParser(
        description="Fix Google Translate fsckeries in a po file.")
    parser.add_argument('pofile')
    parser.add_argument('--doctest')
    parser.add_argument('--only-fuzzy', action='store_true')
    return parser.parse_args()

if __name__ == '__main__':
    if '--doctest' in sys.argv:
        import doctest
        doctest.testmod()
        exit(0)
    fixpo(**vars(parse_args()))
