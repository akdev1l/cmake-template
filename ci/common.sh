# shellcheck shell=bash
# Shared helpers for the ci/ scripts. Source it, don't execute it.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export ROOT_DIR
cd "$ROOT_DIR"

log() {
    printf '\033[1;34m==>\033[0m %s\n' "$*"
}

die() {
    printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
    exit 1
}

# Project name/version as declared in the top-level project() call.
project_name() {
    awk '/^project\(/,/\)/' CMakeLists.txt | sed -n '2p' | tr -d '[:space:]'
}

project_version() {
    awk '/^project\(/,/\)/' CMakeLists.txt \
        | grep -oE 'VERSION[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' \
        | awk '{print $2}'
}
