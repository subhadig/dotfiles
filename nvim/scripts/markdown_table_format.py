#!/usr/bin/env python3

import sys

def parse(text):
    parse_header = True
    parse_header_dash = False
    rows = []
    for line in text.splitlines():
        if parse_header:
            headers = line.split('|')[1:-1]
            parse_header = False
            parse_header_dash = True
        elif parse_header_dash:
            parse_header_dash = False
        else:
            rows.append(line.split('|')[1:-1])

    return (headers, rows)

def get_col_lens_for_row(max_col_lenths, row):
    for index, val in enumerate(row):
        if max_col_lenths[index] < len(val.strip()):
            max_col_lenths[index] = len(val.strip())

def print_row(max_col_lenths, row):
    sys.stdout.write('|')
    for ind, col_len in enumerate(max_col_lenths):
        sys.stdout.write(' ')
        if ind < len(row):
            val = row[ind]
            val = val.strip()
            sys.stdout.write(val)
            for remaining_char in range(col_len - len(val)):
                sys.stdout.write(' ')
        sys.stdout.write(' ')
        sys.stdout.write('|')
    sys.stdout.write('\n')

def format(headers, rows):
    formatted_text = ''
    max_col_lenths = [len(each.strip()) for each in headers]
    for each in rows:
        get_col_lens_for_row(max_col_lenths, each)

    print_row(max_col_lenths, headers)

    sys.stdout.write('|')
    for i in max_col_lenths:
        sys.stdout.write('-')
        for _ in range(i):
            sys.stdout.write('-')
        sys.stdout.write('-|')
    sys.stdout.write('\n')

    for each in rows:
        print_row(max_col_lenths, each)

def main():
    text = ''
    for line in sys.stdin:
        text = text + line

    headers, rows = parse(text)
    format(headers, rows)

if __name__ == '__main__':
    main()
