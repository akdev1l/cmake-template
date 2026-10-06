#!/usr/bin/env bash
# Build the builder image and run a command inside it with the repo mounted.
#
#   ci/container.sh                   # interactive shell
#   ci/container.sh ci/build.sh       # run a CI step
#
# Env:
#   CONTAINER_ENGINE  podman | docker (default: podman if available)
#   BUILDER_IMAGE     image tag (default: localhost/<project>-builder:latest)
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

ENGINE="${CONTAINER_ENGINE:-$(command -v podman || command -v docker || true)}"
[[ -n "$ENGINE" ]] || die "neither podman nor docker found"
IMAGE="${BUILDER_IMAGE:-localhost/$(project_name)-builder:latest}"

log "Building $IMAGE"
"$ENGINE" build --quiet -f Containerfile.builder -t "$IMAGE" . >/dev/null

run_args=(--rm -v "$ROOT_DIR:/src:Z" -w /src -e CI -e GITHUB_ACTIONS)
if [[ -t 0 && -t 1 ]]; then
    run_args+=(-it)
fi
# Rootless podman maps container root to the invoking user; docker needs an
# explicit user so build/ isn't owned by root on the host.
if [[ "$(basename "$ENGINE")" == docker ]]; then
    run_args+=(--user "$(id -u):$(id -g)" -e HOME=/tmp)
fi

if [[ $# -eq 0 ]]; then
    set -- bash
fi
exec "$ENGINE" run "${run_args[@]}" "$IMAGE" "$@"
