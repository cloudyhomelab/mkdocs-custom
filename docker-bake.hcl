variable "REGISTRY"   { default = "docker.io" }
variable "NAMESPACE"  { default = "binarycodes" }
variable "IMAGE_NAME" { default = "mkdocs" }

# set by publish.yml so every published image also carries an immutable tag
variable "GIT_SHA" { default = "" }

variable "LOCAL" { default = false }

group "default" {
  targets = ["image"]
}

target "image" {
  context    = "."
  dockerfile = "Dockerfile"

  labels = {
    "org.opencontainers.image.title"       = "mkdocs"
    "org.opencontainers.image.description" = "MkDocs with the devblog theme, built at start and served by Caddy; mount the directory holding mkdocs.yml and docs/ at /blog (see sample/)"
    "org.opencontainers.image.source"      = "https://github.com/cloudyhomelab/mkdocs-custom"
    "org.opencontainers.image.revision"    = "${GIT_SHA}"
  }

  tags = concat(
    ["${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:latest"],
    GIT_SHA != "" ? ["${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:sha-${substr(GIT_SHA, 0, 12)}"] : [],
  )

  platforms = LOCAL ? [] : ["linux/amd64", "linux/arm64"]
}
