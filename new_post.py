
import argparse
from collections import OrderedDict
from datetime import datetime, timedelta
from pathlib import Path
import subprocess
import platform


nach_books = OrderedDict([
  ('Joshua', 24), ('Judges', 21), ('I Samuel', 31), ('II Samuel', 24), ('I Kings', 22), ('II Kings', 25), ('Isaiah', 66), ('Jeremiah', 52), ('Ezekiel', 48), ('Hosea', 14), ('Joel', 4), ('Amos', 9), ('Obadiah', 1), ('Jonah', 4), ('Micah', 7), ('Nahum', 3), ('Habakkuk', 3), ('Zephaniah', 3), ('Haggai', 2), ('Zechariah', 14), ('Malachi', 3),
  ('Psalms', 150), ('Proverbs', 31), ('Job', 42), ('Song of Songs', 8), ('Ruth', 4), ('Lamentations', 5), ('Ecclesiastes', 12), ('Esther', 10), ('Daniel', 12), ('Ezra', 10), ('Nehemiah', 13), ('I Chronicles', 29), ('II Chronicles', 36)
])


# ========================
#  Command-Line Arguments
# ========================

# From: https://stackoverflow.com/a/14117511
def positive_int(value):
  ivalue = int(value)
  if ivalue <= 0:
    raise argparse.ArgumentTypeError(f'{value} is an invalid positive int value')
  return ivalue

parser = argparse.ArgumentParser(usage = 'new.py [-h] book chapter [-e end-chapter] [--verse]')
parser.add_argument('book', help = 'book of the Tanakh (e.g. "Joshua")')
parser.add_argument('chapter', type = positive_int, help = 'chapter about which to make a new post (e.g. "1")')
parser.add_argument('-v', '--verse', help = 'reference a specific verse or verses')
args = parser.parse_args()

# Ensure the book and chapter given are valid
if args.book not in nach_books:
  raise parser.error(f'{args.book} is not a book in Nach')
chapters = nach_books[args.book]
if args.chapter > chapters:
  raise parser.error(f'{args.chapter} is not a chapter in {args.book}')


# ==================
#  Making the Posts
# ==================

date = datetime(2024, 2, 1)
for book, chapters in nach_books.items():
  if args.book == book:
    date += timedelta(days = args.chapter-1)
    break
  else:
    date += timedelta(days = chapters)

post_book_dir = Path('nach-2024', args.book.replace(' ', '-'))
post_parent_dir = post_book_dir / '_posts'
post_file = post_parent_dir / f'{date.strftime('%Y-%m-%d')}-{args.chapter}.md'

if post_file.exists():
  answer = input(f'WARNING: {post_file} already exists - overwrite it? [y/N] ')
  if answer.lower() not in ["y","yes"]:
    exit()

if not post_book_dir.exists():
  post_book_dir.mkdir(parents=True, exist_ok=True)
  with (post_book_dir / 'index.html').open('w') as f:
    lines = []
    lines.append(f'---')
    lines.append(f'layout: book')
    lines.append(f'title: {args.book}')
    lines.append(f'---')
    f.write('\n'.join(lines))

post_parent_dir.mkdir(parents=True, exist_ok=True)
with post_file.open('w') as f:
  lines = []
  lines.append(f'---')
  lines.append(f'layout: post')
  lines.append(f'includeStatement: 1')
  lines.append(f'book: {args.book}')
  lines.append(f'chapter: {args.chapter}')
  if args.verse:
    lines.append(f'verse: {args.verse}')
  lines.append(f'---')
  if args.verse:
    lines.append(f'')
    lines.append(f'{{% verses %}}')
    lines.append(f'{{% vhe  %}}')
    lines.append(f'{{% vtl  %}}')
    lines.append(f'{{% vtr  %}}')
    lines.append(f'{{% endverses {args.book} {args.chapter}:{args.verse} %}}')
  lines.append(f'\n\n')
  f.write('\n'.join(lines))

if platform.system() == 'Darwin':
  subprocess.call(('open', post_file))
