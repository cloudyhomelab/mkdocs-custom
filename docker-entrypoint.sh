#!/bin/sh
set -eu

# Content is mounted, not baked, so the site is built once per container start;
# restart the container to publish new posts. Any other command (mkdocs serve,
# mkdocs build, ...) runs as given.
if [ "${1:-}" = "caddy" ]; then
	mkdocs build --strict --site-dir /srv/site
fi

exec "$@"
