"""
Shared utilities for fetching verse text from the Sefaria API.

Sefaria API docs: https://developers.sefaria.org/reference/texts-1
  GET /api/texts/{ref}?context=0
  Returns `he` (Hebrew) and `text` (English) fields — strings for a single
  verse, lists for a range.
"""

import html
import json
import re
import urllib.parse
import urllib.request


def strip_html(text: str) -> str:
    """Remove HTML tags (including footnote elements with their content) and decode entities."""
    # Remove footnote markers and their content entirely, e.g.:
    #   <sup class="footnote-marker">a</sup><i class="footnote">...</i>
    text = re.sub(r'<sup[^>]*class="footnote-marker"[^>]*>.*?</sup>', '', text, flags=re.DOTALL)
    text = re.sub(r'<i[^>]*class="footnote"[^>]*>.*?</i>', '', text, flags=re.DOTALL)
    # Remove any remaining tags
    text = re.sub(r'<[^>]+>', '', text)
    return html.unescape(text).strip()


def fetch_verses(ref: str) -> tuple[list[str], list[str]]:
    """
    Fetch Hebrew and English verse text from the Sefaria API for *ref*.

    Args:
        ref: A human-readable reference like 'Joshua 1:1' or 'I Samuel 1:1-3'.

    Returns:
        A (he_verses, en_verses) tuple, each a list of cleaned strings, one
        entry per verse. HTML tags and entities are stripped from both.

    Raises:
        ValueError: If *ref* cannot be parsed.
        urllib.error.URLError: On network failure.
        KeyError: If the API response is missing expected fields.
    """
    url = f"https://www.sefaria.org/api/texts/{urllib.parse.quote(ref, safe='')}?context=0"
    with urllib.request.urlopen(url) as resp:
        data = json.loads(resp.read())

    he = data['he']
    en = data['text']

    # API returns a string for a single verse, a list for a range.
    if isinstance(he, str):
        he = [he]
    if isinstance(en, str):
        en = [en]

    return [strip_html(v) for v in he], [strip_html(v) for v in en]


def build_verses_block(ref: str, he: list[str], en: list[str]) -> str:
    """
    Build a {% verses %} ... {% endverses %} Liquid block.

    Args:
        ref:  The reference string used in the {% endverses %} tag.
        he:   List of Hebrew verse strings (one per verse row).
        en:   List of English translation strings (one per verse row).

    Returns:
        The complete block as a string, with rows separated by {% brverses %}.
        The {% vtl %} (transliteration) column is left empty for manual entry.
    """
    lines = ['{% verses %}']
    for i, (h, e) in enumerate(zip(he, en)):
        if i > 0:
            lines.append('{% brverses %}')
        lines.append(f'{{% vhe {h} %}}')
        lines.append(f'{{% vtl  %}}')
        lines.append(f'{{% vtr {e} %}}')
    lines.append(f'{{% endverses {ref} %}}')
    return '\n'.join(lines)
