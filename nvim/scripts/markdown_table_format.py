#!/usr/bin/env python3

import sys

def parse(text):
    """
    This function parses the input text and returns a tuple consisting of the
    header row and a list of other rows.
    It does not store the second row (the one immediately after the header row
    which consists of only dashes and pipes.

    Each row (header or data) is a list that consists of strings representing
    column data.
    """
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
    """
    Compare the columnt sizes of the current row with the max_col_lengths and
    update max_col_lengths if necessary.
    """
    for index, val in enumerate(row):
        if max_col_lenths[index] < len(val.strip()):
            max_col_lenths[index] = len(val.strip())

def print_row(max_col_lenths, row):
    """
    Print the current row to stdout with proper markdown formatting.
    The columns should be padded with 'space' if the text lengths are lesser
    than the max_col_lengths.
    """
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
    """
    First get the max column lengths for all the rows.
    Then print the header row.
    Print the second row comprised of dashes and pipes.
    Lastly print the data rows one by one.
    """
    formatted_text = ''
    max_col_lenths = [len(each.strip()) for each in headers]
    for each in rows:
        get_col_lens_for_row(max_col_lenths, each)

    print_row(max_col_lenths, headers)

    # Print the second row
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
    # Read the text from stdin
    text = ''
    for line in sys.stdin:
        text = text + line

    # Parse the read text into header row and data rows
    headers, rows = parse(text)

    # Format the rows into a proper markdown table and print to stdout
    format(headers, rows)

if __name__ == '__main__':
    main()
