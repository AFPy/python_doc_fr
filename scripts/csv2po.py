import csv
import polib


def csv2po(csvfile, pofile, msgid_column=0, msgstr_column=1):
    translations = {}
    with open(csvfile) as opened_csvfile:
        dialect = csv.Sniffer().sniff(opened_csvfile.read(1024))
        opened_csvfile.seek(0)
        reader = csv.reader(opened_csvfile, dialect)
        for line in reader:
            translations[line[msgid_column]] = line[msgstr_column]
    po = polib.pofile(pofile)
    for entry in po:
        if entry.msgstr == "" and entry.msgid in translations:
            entry.msgstr = translations[entry.msgid]
            entry.flags.append('fuzzy')
    po.save()


def parse_args():
    import argparse
    parser = argparse.ArgumentParser(
        description="Find traductions in csv file and merge them to a po file.")
    parser.add_argument('csvfile')
    parser.add_argument('pofile')
    parser.add_argument('--msgid-column', default=0)
    parser.add_argument('--msgstr-column', default=1)
    return parser.parse_args()

if __name__ == '__main__':
    csv2po(**vars(parse_args()))
