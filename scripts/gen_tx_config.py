#!/usr/bin/env python3

import os
import argparse

# Map of tx projects slugs with our directories:
PROJECTS = {'python-35': '3.5/',
            'python-27': '2.7/'}


def parse_args():
    parser = argparse.ArgumentParser(
        description='Generates a .tx/config from our files.')
    parser.add_argument('config', metavar='.tx/config',
                        help='Output config file.')
    return parser.parse_args()


def conf_for_file(project_slug, root, po_file):
    resource_slug = po_file.replace('/', '--').replace('.po', '')
    if resource_slug == 'glossary':
        # Reserved by transifex :-(
        resource_slug = 'glossary-1'
    return """[{}.{}]
trans.fr = {}
type = PO
source_lang = en

""".format(project_slug, resource_slug, os.path.join(root, po_file))


def main(config):
    with open(config, 'w') as config_file:
        config_file.write("[main]\nhost = https://www.transifex.com\n")
        for slug, root in PROJECTS.items():
            if root[-1] != '/':
                root = root + '/'
            for relative_root, dirs, files in os.walk(root):
                for po_file in files:
                    config_file.write(conf_for_file(slug, root, os.path.join(
                        relative_root, po_file)[len(root):]))


if __name__ == '__main__':
    main(**vars(parse_args()))
