#!/usr/bin/env python3

"""Fix style of uncommited po files, or all if --all is given.

The "tac|tac" trick is an equivalent to "sponge" but as tac is in
coreutils we're avoiding you to install a new packet.  Without
`tac|tac` or `sponge`, `msgcat` may start to write in the po file
before having finised to read it, yielding unpredictible behavior.
(Yep we also can write to another file and mv it, like sed -i does.)
"""

from tqdm import tqdm
from glob import glob
from shlex import quote
from subprocess import check_output


def fix_style(all_files=False, no_wrap=False):
    find_modified_files = "git status | grep 'modified.*\.po$' | rev | cut -d' ' -f1 | rev"
    for po in tqdm(glob('*/*.po') if all_files else
                   check_output(find_modified_files, shell=True).decode().split(),
                   desc="Fixing indentation in po files"):
        check_output('tac {} | tac | msgcat - -o {} {}'.format(
            quote(po), quote(po), '--no-wrap' if no_wrap else ''),
                     shell=True)

if __name__ == '__main__':
    import sys
    import argparse
    parser = argparse.ArgumentParser(
        description='Ensure po files are using the standard gettext format')
    parser.add_argument('--all', '-a', action='store_true',
                        help='Recheck all files, not only modified ones.')
    parser.add_argument('--no-wrap', action='store_true',
                        help='see `man msgcat`, usefull for sed.')
    args = parser.parse_args()
    fix_style(args.all, args.no_wrap)
