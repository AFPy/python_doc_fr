#!/usr/bin/env python3
""" Check translation progress and format output """
import sys
from os import getcwd, listdir
from os.path import join, isdir
from polib import pofile


def usage():
    """ Print usage """
    msg = "progression.py --update-readme README.rst"
    print(msg)


def check_progress():
    """ Check translation progress for each subdirectory of each version """
    main_path = getcwd()
    status_dict = dict()
    # for each version
    for ver in listdir(main_path):
        if ver[:2] in ("2.", "3."):
            status_dict[ver] = dict()
            ver_path = join(main_path, ver)
            ver_total = 0
            ver_translated = 0

            # for each .po file in the root folder of the version
            for elem in listdir(ver_path):
                elem_path = join(ver_path, elem)
                if elem.endswith(".po"):
                    pof = pofile(elem_path)
                    pof_total = len(pof)
                    pof_translated = len(pof.translated_entries())

                    # store data for this file
                    status_dict[ver][elem] = 100. * pof_translated / pof_total

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
                    status_dict[ver][elem] = 100. * module_translated / module_total

                    # store data for version
                    ver_total += module_total
                    ver_translated += module_translated
                else:
                    pass

            status_dict[ver]["Total"] = 100. * ver_translated / ver_total

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

if __name__ == "__main__":
    # whatever options are passed : check the progress
    res = check_progress()
    msg = format_progress(res)

    # if output is specified store results in it
    #FIXME: it will erase the README.rst instead of updating it
    if len(sys.argv) == 3 and sys.argv[1] == "--update-readme":
        with open(sys.argv[2], 'w') as f:
            for elem in msg:
                f.write(elem)
    else:
        print(msg)
