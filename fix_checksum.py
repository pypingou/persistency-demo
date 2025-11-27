#!/usr/bin/env python3
import json
import hashlib
import os
import sys

def update_checksum_file():
    """Update .cargo-checksum.json to remove references to deleted files"""
    if not os.path.exists('.cargo-checksum.json'):
        return

    # Load existing checksum data
    with open('.cargo-checksum.json', 'r') as f:
        data = json.load(f)

    # Rebuild files dict with only existing files
    files = {}
    for filename in data['files']:
        if os.path.exists(filename):
            with open(filename, 'rb') as f:
                files[filename] = hashlib.sha256(f.read()).hexdigest()

    # Update data and write back
    data['files'] = files
    with open('.cargo-checksum.json', 'w') as f:
        json.dump(data, f, separators=(',', ':'))

if __name__ == '__main__':
    update_checksum_file()