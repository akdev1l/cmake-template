#!/usr/bin/env bash
# Validate a release tag: it must be SemVer (vMAJOR.MINOR.PATCH[-pre][+build])
# and its MAJOR.MINOR.PATCH must match project(VERSION) in CMakeLists.txt.
# Usage: ci/check-version.sh v1.2.3
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

TAG="${1:?usage: $0 <tag>}"
SEMVER_RE='^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'

[[ "$TAG" =~ $SEMVER_RE ]] || die "tag '$TAG' is not a valid SemVer tag (expected vX.Y.Z)"

TAG_CORE="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
CMAKE_VERSION="$(project_version)"
[[ "$TAG_CORE" == "$CMAKE_VERSION" ]] \
    || die "tag $TAG does not match project version $CMAKE_VERSION in CMakeLists.txt"

log "Tag $TAG matches project version $CMAKE_VERSION"
