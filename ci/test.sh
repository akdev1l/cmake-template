#!/usr/bin/env bash
# Build and run the test suite. Usage: ci/test.sh [preset]   (default: debug)
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

PRESET="${1:-debug}"

"$ROOT_DIR/ci/build.sh" "$PRESET"
log "Testing ($PRESET)"
ctest --preset "$PRESET" --output-junit "$ROOT_DIR/build/$PRESET/test-results.xml"
