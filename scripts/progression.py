#!/usr/bin/env python3
""" Check translation progress and format output """
import re
import sys
from collections import OrderedDict
from os import getcwd, listdir
from os.path import join, isdir
from polib import pofile


def check_version_progress(ver_path):
    status = OrderedDict()
    ver_total = 0
    ver_translated = 0
    for elem in sorted(listdir(ver_path)):
        elem_path = join(ver_path, elem)
        if elem.endswith(".po"):
            pof = pofile(elem_path)
            pof_total = len(pof)
            pof_translated = len(pof.translated_entries())

            # store data for this file
            status[elem] = 100. * pof_translated / pof_total

            # store data for version
            ver_total += pof_total
            ver_translated += pof_translated

        elif isdir(elem_path):
            module_total = 0
            module_translated = 0
            for fic in listdir(elem_path):
                if fic.endswith(".po"):
                    pof = pofile(join(elem_path, fic))
                    pof_total = len(pof)
                    pof_translated = len(pof.translated_entries())

                    # store data for module
                    module_total += pof_total
                    module_translated += pof_translated

            # store data for this module
            status[elem] = 100. * module_translated / module_total

            # store data for version
            ver_total += module_total
            ver_translated += module_translated
        else:
            pass
    status["Total"] = 100. * ver_translated / ver_total
    return status


def check_progress():
    """ Check translation progress for each subdirectory of each version """
    main_path = getcwd()
    status_dict = OrderedDict()
    for ver in listdir(main_path):
        if ver[:2] in ("2.", "3."):
            ver_path = join(main_path, ver)
            status_dict[ver] = check_version_progress(ver_path)
    return status_dict


def format_progress(progress):
    tmp = "=" * 12  # block name column
    tmp += " ======" * len(progress)  # version columns
    tmp += "\n"
    tmp2 = tmp.replace("=", "-")

    # make title columns
    res = tmp
    res += " " * 12
    for ver in progress:
        res += " %6s" % ver
    res += "\n" + tmp2
    # for each block, add a ligne
    #TODO: change the access at 2.7 by something more adaptative
    for block in progress["2.7"]:
        if block == "Total":
            continue
        if block.endswith(".po"):
            blockname = block[:-3]
        else:
            blockname = block
        res += "%12s" % blockname
        for ver in progress:
            res += " %5d%%" % progress[ver][block]
        res += "\n"

    # Add total line
    res += "%12s" % "Total"
    for ver in progress:
        res += " %5d%%" % progress[ver]["Total"]
    res += "\n"

    res += tmp
    return res


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
        table_boundaries = '============ ====== ====== ======'
        new_readme = re.sub(table_boundaries + '.*' + table_boundaries,
                            msg.strip(),
                            old_readme, flags=re.S)
        readme.write(new_readme)
        readme.truncate()
    else:
        print(msg)


if __name__ == "__main__":
    main(**(vars(parse_args())))
