# mkdocs-custom

A Docker image for a Markdown dev blog: MkDocs with the [devblog theme](theme/README.md),
built at container start and served by Caddy. Content is not baked in; mount the
directory holding `mkdocs.yml` and `docs/` at `/blog`, as in [`sample/`](sample/).
The site is built to `/srv/site`, so the mount can be read-only.

```sh
docker run --rm -p 8000:8000 -v "$PWD:/blog:ro" docker.io/binarycodes/mkdocs:latest
```

The build is strict, so a broken post stops the container instead of serving a broken
site. Restart the container to publish new content. Caddy listens on port 8000 over
plain HTTP; terminate TLS in front of it.

## Writing posts

Override the command to run the MkDocs dev server with live reload:

```sh
docker run --rm -p 8000:8000 -v "$PWD:/blog:ro" \
  docker.io/binarycodes/mkdocs:latest mkdocs serve --dev-addr=0.0.0.0:8000
```

`mkdocs build --strict` works the same way; mount a writable directory at `/blog/site`
to collect the output.

## Image

Published to Docker Hub as `binarycodes/mkdocs` for amd64 and arm64, tagged
`latest` and `sha-<commit>`, with provenance and SBOM attestations and a keyless
cosign signature. Post front matter and site options are documented in the
[theme README](theme/README.md).
