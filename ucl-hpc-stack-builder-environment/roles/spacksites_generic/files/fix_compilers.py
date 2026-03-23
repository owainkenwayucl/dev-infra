#!/usr/bin/env python3

import yaml
import sys

if not(len(sys.argv) ==2):
        print("Call with argument of compilers yaml to fix.")
        sys.exit(1)

filename = sys.argv[1]
data = []

with open(filename, 'r', encoding='utf-8') as file:
        data = yaml.safe_load(file)

for compiler in data['compilers']:
        if compiler['compiler']['paths']['cc'].endswith('icx') or compiler['compiler']['paths']['cc'].endswith('icc'):
                path = compiler['compiler']['paths']['cc'].rsplit('/', maxsplit=1)[0]
                print(f"Updating {compiler['compiler']['spec']} with path {path}")
                compiler['compiler']['environment']['prepend_path'] = {'PATH': path}

with open(filename, 'w', encoding='utf-8') as file:
        yaml.safe_dump(data, file, sort_keys=False, allow_unicode=True)

