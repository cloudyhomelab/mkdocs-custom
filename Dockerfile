FROM python:3.13-alpine@sha256:7415fbc3c9e4979cc717d92377ab2bc7b2b4a2af1ac03cc52b5f3f88efedaf3a
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

RUN addgroup -S "${MKDOCS_USER}" \
    && adduser -S -G "${MKDOCS_USER}" -h /blog "${MKDOCS_USER}"

USER "${MKDOCS_USER}"
WORKDIR /blog

EXPOSE 8000

ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
