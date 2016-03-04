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


def fix_style(all_files=False):
    find_modified_files = "git status | grep 'modified.*\.po$' | rev | cut -d' ' -f1 | rev"
    for po in tqdm(glob('*/*.po') if all_files else
                   check_output(find_modified_files, shell=True).decode().split(),
                   desc="Fixing indentation in po files"):
        check_output('tac {} | tac | msgcat - -o {}'.format(
            quote(po), quote(po)), shell=True)

if __name__ == '__main__':
    import sys
    fix_style('--all' in sys.argv)
