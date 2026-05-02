
# Matt's Nach Yomi Blog

A daily blog of my thoughts as I study [Nach Yomi](https://outorah.org/p/183910/).

To preview the site locally at `http://localhost:4000/yomi/`, run:
```sh
bundle exec jekyll serve --livereload --future
```

## Adding a New Post

Use `new_post.py` to scaffold a post file and open it:

```sh
python3 new_post.py "I Samuel" 5          # creates nach/I-Samuel/_posts/<date>-5.md
python3 new_post.py "Joshua" 3 -v 1-4     # same, but pre-fills an empty verses block for 3:1-4
```

Then, add `enTitle`, `heTitle`, and/or `tlTitle` for the post title, and `tags: fav` to mark a favorite.

## Custom Plugins

### Inline Hebrew

```liquid
{{ 'הנה' | he }}                   <!-- Hebrew only -->
{{ 'הנה' | he: 'hineh'  }}         <!-- Hebrew with transliteration -->
{{ 'הנה' | he: 'hineh', 'here' }}  <!-- Hebrew with transliteration and translation -->
{{ 'הנה' | he: nil, 'here' }}      <!-- Hebrew with just translation -->
```

### Automatic links

```liquid
{{ 'Joshua 1:1' | sefaria }}  <!-- Link to Joshua 1:1 on Sefaria -->
{% my_notes_on Joshua 1 %}    <!-- Link to the Joshua 1 post, with the text:
                                              "my notes on Joshua 1" -->
{% post_ref Joshua 1 %}       <!-- URL of the Joshua 1 post, for a custom link -->
```

### Verses blocks

- Open a verses block with `{% verses %}` and close it with either `{% endverses %}`, which adds a link to Sefaria automatically using its argument, or `{% endversesnolink %}` to add custom text/links. Use `{% scaledverses %}` with a percentage instead of `{% verses %}` to scale the font size.
- Use `{% vhe %}`, `{% vgk %}`, `{% vtl %}`, or `{% vtr %}` to add a column which formats its argument as Hebrew, Greek, transliteration, or translation, respectively.
- Use `{% brverses %}` to start a new row, or `{% brdotsverses %}` to add a row with three columns (`{% vhe %}`, `{% vtl %}`, and `{% vtr %}`) all filled `…`, then start a new row - used to indicate that something has been skipped.
