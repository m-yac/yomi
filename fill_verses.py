#!/usr/bin/env python3
"""
fill_verses.py — Replace {% addverses <ref> %} tags with Sefaria-prefilled verses blocks.

Scans one or more markdown files for lines containing:
  {% addverses Book Chapter:Verse[-EndVerse] %}

and replaces each with a fully-formed {% verses %} block whose Hebrew and
English columns are fetched from the Sefaria API.  The transliteration column
({% vtl %}) is left blank for manual entry.

Usage:
  python fill_verses.py <file> [<file> ...]   # process specific files
  python fill_verses.py --all                  # process all posts under nach/
"""

import argparse
import sys
from pathlib import Path

from sefaria import build_verses_block, fetch_verses


ADDVERSES_RE = __import__('re').compile(r'\{%\s*addverses\s+(.+?)\s*%\}')


def process_text(text: str) -> str:
    """Replace all {% addverses ... %} occurrences in *text* with verses blocks."""
    def replace(match):
        ref = match.group(1)
        print(f"  Fetching {ref!r} ... ", end='', flush=True)
        try:
            he, en = fetch_verses(ref)
            block = build_verses_block(ref, he, en)
            print("ok")
            return block
        except Exception as exc:
            print(f"FAILED ({exc})")
            return match.group(0)  # leave unchanged on error

    return ADDVERSES_RE.sub(replace, text)


def process_file(path: Path) -> bool:
    """Process *path* in-place.  Returns True if the file was modified."""
    original = path.read_text(encoding='utf-8')
    if not ADDVERSES_RE.search(original):
        return False
    print(f"{path}:")
    updated = process_text(original)
    if updated != original:
        path.write_text(updated, encoding='utf-8')
        return True
    return False


def main():
    parser = argparse.ArgumentParser(
        description='Replace {% addverses <ref> %} with Sefaria-prefilled verses blocks.',
    )
    parser.add_argument(
        'files', nargs='*', type=Path,
        help='Markdown files to process',
    )
    parser.add_argument(
        '--all', action='store_true',
        help='Process all markdown posts under nach/',
    )
    args = parser.parse_args()

    if args.all:
        files = sorted(Path('nach').rglob('*/_posts/*.md'))
    elif args.files:
        files = args.files
    else:
        parser.print_help()
        sys.exit(1)

    changed = 0
    for path in files:
        if process_file(path):
            changed += 1

    print(f"\nDone. {changed} file(s) modified.")


if __name__ == '__main__':
    main()
