#!/usr/bin/env bash
# Build source tarball, SRPM and RPMs into build/rpm/.
# Usage: ci/package.sh [version]   (default: version from CMakeLists.txt)
# SemVer pre-release tags (1.2.0-rc.1) are mapped to RPM's 1.2.0~rc.1.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

NAME="$(project_name)"
VERSION="${1:-$(project_version)}"
RPM_VERSION="${VERSION//-/\~}"
SPEC="packaging/$NAME.spec"
TOPDIR="$ROOT_DIR/build/rpm"
TARBALL="$TOPDIR/SOURCES/$NAME-$RPM_VERSION.tar.gz"

[[ -f "$SPEC" ]] || die "spec file not found: $SPEC"

rm -rf "$TOPDIR"
mkdir -p "$TOPDIR/SOURCES"

log "Creating $(basename "$TARBALL")"
tar -C "$ROOT_DIR" \
    --exclude=./build --exclude=./.git --exclude=./.cache \
    --transform "s,^\.,$NAME-$RPM_VERSION," \
    -czf "$TARBALL" .

log "Running rpmbuild ($RPM_VERSION)"
rpmbuild -ba \
    --define "_topdir $TOPDIR" \
    --define "pkg_version $RPM_VERSION" \
    "$SPEC"

log "rpmlint"
rpmlint -r packaging/rpmlintrc "$TOPDIR"/SRPMS/*.rpm "$TOPDIR"/RPMS/*/*.rpm

log "Artifacts:"
find "$TOPDIR/SRPMS" "$TOPDIR/RPMS" -name '*.rpm' -printf '  %P\n'
