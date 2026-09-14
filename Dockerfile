FROM caddy:2.11.4-alpine@sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648 AS caddy

FROM python:3.14-alpine@sha256:c6ead215bfd31f1e433d968853b7a769989117115b728874824e6c0a27cb96fc
SHELL ["/bin/sh", "-eu", "-c"]

ARG MKDOCS_USER="mkdocs"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt \
    && rm /tmp/requirements.txt

# the theme is a regular MkDocs theme package, so mkdocs.yml selects it by
# name and never needs a path into the image
COPY pyproject.toml /tmp/devblog/
COPY theme /tmp/devblog/theme
RUN pip install --no-cache-dir /tmp/devblog \
    && rm -rf /tmp/devblog

# caddy is a static binary; only it is taken from the official image
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
RUN caddy validate --config /etc/caddy/Caddyfile

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# the site is built outside /blog so the whole blog directory can be mounted read-only
RUN addgroup -S "${MKDOCS_USER}" \
    && adduser -S -G "${MKDOCS_USER}" -h /blog "${MKDOCS_USER}" \
    && install -d -o "${MKDOCS_USER}" -g "${MKDOCS_USER}" /srv/site

USER "${MKDOCS_USER}"
WORKDIR /blog

EXPOSE 8000

# the site is built before caddy starts, so allow for that in the start period
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --start-interval=5s \
    CMD ["wget", "-q", "--spider", "http://127.0.0.1:8000/"]

ENTRYPOINT ["docker-entrypoint"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
