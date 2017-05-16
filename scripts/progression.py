#!/usr/bin/env python3
""" Check translation progress and format output """

import re
from collections import OrderedDict
from os import getcwd, listdir
from os.path import join, isdir
from polib import pofile


def postat(*args):
    """From one or many po files path, give a tuple of (translated, total).
    """
    total = 0
    translated = 0
    for pofile_path in args:
        po_file = pofile(pofile_path)
        total += len([entry for entry in po_file if not entry.obsolete])
        translated += len(po_file.translated_entries())
    return translated, total


def check_version_progress(ver_path):
    status = OrderedDict()
    for elem in sorted(listdir(ver_path)):
        elem_path = join(ver_path, elem)
        if elem.endswith(".po"):
            # Stats for a po file
            status[elem] = postat(elem_path)
        elif isdir(elem_path):
            # Stats for a module (directory of po files)
            status[elem] = postat(*[join(elem_path, fic) for
                                    fic in listdir(elem_path) if
                                    fic.endswith('.po')])
    status["~total~"] = (sum(translated for translated, _ in status.values()),
                         sum(total for _, total in status.values()))
    return status


def check_progress():
    """ Check translation progress for each subdirectory of each version """
    main_path = getcwd()
    status_dict = OrderedDict()
    for ver in sorted(listdir(main_path)):
        if ver[:2] in ("2.", "3."):
            ver_path = join(main_path, ver)
            status_dict[ver] = check_version_progress(ver_path)
    return status_dict


def format_progress(progress):
    from tabulate import tabulate
    from itertools import chain
    lines = sorted(set(chain(*[list(d.keys()) for d in progress.values()])))
    columns = list(progress.keys())
    def format(x):
        if x is None:
            return 'ø'
        return "%d%%" % (100. * x[0] / x[1])
    table = [[line] + [format(progress[column].get(line))
                       for column in columns]
             for line in lines]
    return tabulate(table, columns, tablefmt='rst',
                    stralign='right')


def parse_args():
    from argparse import ArgumentParser, FileType
    parser = ArgumentParser(
        description='Count translated blocks per file.')
    parser.add_argument('--update-readme',
                        type=FileType('r+'),
                        help='Update rst table in README.rst file.',
                        default=None,
                        metavar='README.rst',
                        dest='readme')
    return parser.parse_args()


def main(readme=None):
    # whatever options are passed : check the progress
    res = check_progress()
    msg = format_progress(res)

    # if output is specified store results in it
    if readme:
        old_readme = readme.read()
        readme.seek(0)
        table_boundaries = '============  =====  =====  ====='
        new_readme = re.sub(table_boundaries + '.*' + table_boundaries,
                            msg.strip(),
                            old_readme, flags=re.S)
        readme.write(new_readme)
        readme.truncate()
    else:
        print(msg)


if __name__ == "__main__":
    main(**(vars(parse_args())))
