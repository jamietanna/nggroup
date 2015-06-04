ROOT_DIR = "."

USER_DIR = "%s/users" % ROOT_DIR

import csv

CSV_DELIM = ','
CSV_QUOTECHAR = '|'
CSV_QUOTING = csv.QUOTE_MINIMAL


def getCSVReader(fileObject):
    return csv.reader(
        fileObject,
        delimiter=CSV_DELIM,
        quotechar=CSV_QUOTECHAR,
        )


def getCSVWriter(fileObject):
    return csv.writer(
        fileObject,
        delimiter=CSV_DELIM,
        quotechar=CSV_QUOTECHAR,
        quoting=CSV_QUOTING
        )
