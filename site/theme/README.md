# Theme

Standalone MkDocs theme (no parent theme). Wire it up in `mkdocs.yml` with
`theme: {name: null, custom_dir: theme, include_search_page: true}`.

## Layout

- `base.html` — document shell, header, footer, colour-mode bootstrap.
- `main.html` — renders `partials/home.html` for the homepage and
  `partials/article.html` for everything else.
- `browse.html`, `search.html`, `404.html` — static pages.
- `css/theme.css` — all styling; palettes are the custom properties at the top.
- `js/theme.js` — light/dark toggle and contents highlighting.

## Post front matter

```yaml
title: Post title            # required; do not repeat it as an H1 in the body
description: One-line deck   # shown under the title and in lists
date: 2026-09-14             # sorts the homepage, newest first
type: Guide                  # kicker label; posts typed "Log" go in the Logs column
tags: [MCP, Java]
image: assets/lede.jpg       # optional lede image
updated: 2026-10-01          # optional, shown in the kicker
featured: true               # optional, pins the post to the hero
notes:                       # optional key/value list under Contents
  Tested on: Caddy 2.8
```

## Site config (`extra`)

```yaml
extra:
  author: {name: ..., bio: ...}          # byline and author card
  social: [{label: GitHub, handle: ..., url: ...}]
  links: [{label: About, url: about/}]   # extra header links
  type_labels: {Hardware: Hardware}      # plural label per type; default adds "s"
  type_order: [Guide, Log]               # otherwise ordered by newest post
  home_limit: 6                          # rows per type on the homepage
```

Posts are grouped by `type` (untyped posts are "Post"). Each type gets a header link,
a homepage section, and a filter on `browse.html`, which also filters by tag.
Header navigation also shows any top-level `nav` sections.
