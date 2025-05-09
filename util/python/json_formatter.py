#!/bin/env /usr/bin/python3

import argparse
import json


def format_json(filename: str):
    with open(filename, 'rt') as fp:
        content = json.load(fp)
    print(json.dumps(content, indent=2))

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('file', type=str)
    args = parser.parse_args()
    return args.file

def main():
    filename = parse()
    format_json(filename)


if __name__ == '__main__':
    main()
