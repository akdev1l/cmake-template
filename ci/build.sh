#!/usr/bin/env bash
# Configure and build. Usage: ci/build.sh [preset]   (default: debug)
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

PRESET="${1:-debug}"

log "Configuring ($PRESET)"
cmake --preset "$PRESET"
log "Building ($PRESET)"
cmake --build --preset "$PRESET"
