#!/usr/bin/env bash
# Generate Doxygen docs into build/debug/docs/html and archive them.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

log "Configuring (debug)"
cmake --preset debug
log "Generating docs"
cmake --build --preset docs

tar -C build/debug/docs -czf build/docs.tar.gz html
log "Docs: build/debug/docs/html/index.html (archive: build/docs.tar.gz)"
