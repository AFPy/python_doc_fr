#!/usr/bin/env python3

import os
import argparse

# Map of tx projects slugs with our directories:
PROJECTS = {'python-35': '3.5/',
            'python-36': '3.6/',
            'python-27': '2.7/'}


def parse_args():
    parser = argparse.ArgumentParser(
        description='Generates a .tx/config from our files.')
    parser.add_argument('config', metavar='.tx/config',
                        help='Output config file.')
    return parser.parse_args()


def conf_for_file(project_slug, root, po_file):
    version = root.strip('/')
    resource_slug = po_file[:-3].replace('/', '--').replace('.', '_')
    if resource_slug == 'glossary':
        # Reserved by transifex :-(
        resource_slug = 'glossary_'
    return """[{}.{}]
trans.fr = {}
type = PO
source_lang = en
source_file = {}

""".format(project_slug, resource_slug,
           os.path.join('.tx', root, po_file),
           os.path.join('gen', 'src', version, 'pot', po_file[:-3] + '.pot'))


def main(config):
    with open(config, 'w') as config_file:
        config_file.write("[main]\nhost = https://www.transifex.com\n")
        for slug, root in PROJECTS.items():
            if root[-1] != '/':
                root = root + '/'
            for relative_root, dirs, files in os.walk(root):
                for po_file in files:
                    if not po_file.endswith('.po'):
                        continue
                    config_file.write(conf_for_file(slug, root, os.path.join(
                        relative_root, po_file)[len(root):]))


if __name__ == '__main__':
    main(**vars(parse_args()))
